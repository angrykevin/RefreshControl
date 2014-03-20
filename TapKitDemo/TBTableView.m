//
//  TBTableView.m
//  TapKitDemo
//
//  Created by Wu Kevin on 3/19/14.
//  Copyright (c) 2014 Telligenty. All rights reserved.
//

#import "TBTableView.h"

@implementation TBTableView

- (id)init
{
  self = [super initWithFrame:CGRectZero style:UITableViewStylePlain];
  if (self) {
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  if ( _refreshControl ) {
    [_refreshControl sizeToFit];
    
    CGFloat maxY = 0.0 - _refreshControl.height;
    CGFloat offsetY = self.contentOffset.y;
    
    // At top
    _refreshControl.frame = CGRectMake(0.0, MIN( offsetY, maxY ), self.width, _refreshControl.height);
    
    // At middle
//    if ( offsetY<maxY ) {
//      _refreshControl.frame = CGRectMake(0.0, (offsetY+maxY)/2.0, self.width, _refreshControl.height);
//    } else {
//      _refreshControl.frame = CGRectMake(0.0, maxY, self.width, _refreshControl.height);
//    }
  }
  
  if ( _infiniteRefreshControl ) {
    
    [_infiniteRefreshControl sizeToFit];
    _infiniteRefreshControl.frame = CGRectMake(0.0, MAX(self.contentSize.height, self.height),
                                               _infiniteRefreshControl.width, _infiniteRefreshControl.height);
    
  }
  
}


- (void)setShowsRefreshControl:(BOOL)showsRefreshControl
{
  _showsRefreshControl = showsRefreshControl;
  if ( _showsRefreshControl ) {
    if ( _refreshControl==nil ) {
      _refreshControl = [[UIRefreshControl alloc] init];
    }
    if ( _refreshControl.superview!=self ) {
      [_refreshControl removeFromSuperview];
      [self addSubview:_refreshControl];
    }
    [_refreshControl sendToBack];
    UITableViewController *tvc = [[UITableViewController alloc] init];
    tvc.tableView = self;
    tvc.refreshControl = _refreshControl;
  } else {
    [_refreshControl removeFromSuperview];
    _refreshControl = nil;
  }
}

- (void)setShowsInfiniteRefreshControl:(BOOL)showsInfiniteRefreshControl
{
  _showsInfiniteRefreshControl = showsInfiniteRefreshControl;
  if ( _showsInfiniteRefreshControl ) {
    if ( _infiniteRefreshControl==nil ) {
      _infiniteRefreshControl = [[TBRefreshControl alloc] init];
    }
    if ( _infiniteRefreshControl.superview!=self ) {
      [_infiniteRefreshControl removeFromSuperview];
      [self addSubview:_infiniteRefreshControl];
    }
    [_infiniteRefreshControl sendToBack];
    
    [_infiniteRefreshControl sizeToFit];
    _infiniteRefreshControl.frame = CGRectMake(0.0, MAX(self.contentSize.height, self.height),
                                               _infiniteRefreshControl.width, _infiniteRefreshControl.height);
    [self resetBottomEdgeInset];
  } else {
    [self removeInfiniteRefreshControl];
    [self resetBottomEdgeInset];
  }
}


- (void)startRefreshing:(BOOL)animated
{
  if ( _refreshControl ) {
    _launchRefreshProgrammatically = YES;
    [_refreshControl beginRefreshing];
    [self setContentOffset:CGPointMake(0.0, 0.0-_refreshControl.height) animated:animated];
  }
}

- (void)stopRefreshing:(BOOL)animated
{
  if ( _refreshControl ) {
    _launchRefreshProgrammatically = NO;
    [_refreshControl endRefreshing];
    [self setContentOffset:CGPointZero animated:animated];
  }
}


- (void)startInfiniteRefreshing:(BOOL)animated
{
  if ( _infiniteRefreshControl ) {
    [_infiniteRefreshControl beginRefreshing];
    [self setContentOffset:CGPointMake(0.0, _infiniteRefreshControl.bottomY - self.height) animated:animated];
  }
}

- (void)stopInfiniteRefreshing:(BOOL)animated
{
  if ( _infiniteRefreshControl ) {
    [_infiniteRefreshControl endRefreshing];
  }
}

- (void)stopInfiniteRefreshingAndHide:(BOOL)animated
{
  if ( _infiniteRefreshControl ) {
    CGFloat offsetY = self.contentOffset.y;
    CGFloat contentHeight = self.contentSize.height;
    CGFloat scrollViewHeight = self.height;
    if ( (offsetY+scrollViewHeight) > contentHeight ) {
      CGFloat newOffsetY = contentHeight - scrollViewHeight;
      if ( animated ) {
        [UIView animateWithDuration:0.25
                         animations:^{
                           [self setContentOffset:CGPointMake(0.0, MAX(0.0, newOffsetY)) animated:NO];
                         }
                         completion:^(BOOL finished) {
                           [self removeInfiniteRefreshControl];
                           [self resetBottomEdgeInset];
                         }];
      } else {
        [self setContentOffset:CGPointMake(0.0, MAX(0.0, newOffsetY)) animated:NO];
        [self removeInfiniteRefreshControl];
        [self resetBottomEdgeInset];
      }
    } else {
      [self removeInfiniteRefreshControl];
      [self resetBottomEdgeInset];
    }
  }
}


- (void)removeInfiniteRefreshControl
{
  [_infiniteRefreshControl removeFromSuperview];
  _infiniteRefreshControl = nil;
  _showsInfiniteRefreshControl = NO;
}

- (void)resetBottomEdgeInset
{
  if ( _infiniteRefreshControl ) {
    UIEdgeInsets edgeInsets = self.contentInset;
    edgeInsets.bottom = _infiniteRefreshControl.height;
    [self setContentInset:edgeInsets];
  } else {
    UIEdgeInsets edgeInsets = self.contentInset;
    edgeInsets.bottom = 0.0;
    [self setContentInset:edgeInsets];
  }
}

@end


@implementation TBRefreshControl

- (id)init
{
  self = [super init];
  if (self) {
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped = NO;
    [_activityIndicatorView stopAnimating];
    [self addSubview:_activityIndicatorView];
    
    _triggered = NO;
    
    _refreshing = NO;
  }
  return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
  return CGSizeMake(320.0, 44.0);
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [_activityIndicatorView sizeToFit];
  [_activityIndicatorView moveToCenterOfSuperview];
  
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
  if ( self.superview ) {
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    [self.superview removeObserver:self forKeyPath:@"contentSize"];
    [self.superview removeObserver:self forKeyPath:@"pan.state"];
  }
  
  if ( newSuperview ) {
    [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    [newSuperview addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    [newSuperview addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:NULL];
  }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  UIScrollView *scrollView = (UIScrollView *)(self.superview);
  
  if ( [keyPath isEqualToString:@"contentOffset"] ) {
    
    if ( !_refreshing ) {
      
      CGFloat offsetY = scrollView.contentOffset.y;
      CGFloat topY = self.topY;
      
      if ( scrollView.isDragging ) {
        if ( ((offsetY+scrollView.height)-topY) >= (0.6*self.height) ) {
#ifdef DEBUG
          if ( !_triggered ) NSLog(@"triggered");
#endif
          _triggered = YES;
        } else {
#ifdef DEBUG
          if ( _triggered ) NSLog(@"cancel triggered");
#endif
          _triggered = NO;
        }
      } else {
        if ( _triggered ) {
#ifdef DEBUG
          NSLog(@"offset change launch");
#endif
          [self sendActionsForControlEvents:UIControlEventValueChanged];
          [self beginRefreshing];
        }
      }
      
    }
    
  } else if ( [keyPath isEqualToString:@"pan.state"] ) {
    
    if ( !_refreshing ) {
      if ( _triggered ) {
#ifdef DEBUG
        NSLog(@"end drag launch");
#endif
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self beginRefreshing];
      }
    }
    
  } else if ( [keyPath isEqualToString:@"contentSize"] ) {
    
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat height = scrollView.height;
    
    self.frame = CGRectMake(0.0, MAX(contentHeight, height), self.width, self.height);
    
  }
}


- (void)beginRefreshing
{
  _refreshing = YES;
  
  [_activityIndicatorView startAnimating];
  
}

- (void)endRefreshing
{
  _triggered = NO;
  
  _refreshing = NO;
  
  [_activityIndicatorView stopAnimating];
  
  UIScrollView *scrollView = (UIScrollView *)(self.superview);
  CGFloat offsetY = scrollView.contentOffset.y;
  CGFloat contentHeight = scrollView.contentSize.height;
  CGFloat scrollViewHeight = scrollView.height;
  if ( (offsetY+scrollViewHeight) > contentHeight ) {
    CGFloat newOffsetY = contentHeight - scrollViewHeight;
    [scrollView setContentOffset:CGPointMake(0.0, MAX(0.0, newOffsetY)) animated:YES];
  }
}

@end
