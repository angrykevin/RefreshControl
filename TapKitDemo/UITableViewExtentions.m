//
//  UITableViewExtentions.m
//  Teemo
//
//  Created by Wu Kevin on 11/22/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "UITableViewExtentions.h"

@implementation UITableView (Extentions)


- (void)updateTableWithNewRowCount:(int)rowCount
{
  // TODO: 可能还应该考虑下拉刷新的时候contentInset.top为正值这种情况。
  CGPoint offset = [self contentOffset];
  
  [UIView setAnimationsEnabled:NO];
  
  [self beginUpdates];
  
  NSMutableArray *array = [[NSMutableArray alloc] init];
  CGFloat height = 0.0;
  
  for ( int i=0; i<rowCount; ++i ) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
    
    [array addObject:indexPath];
    CGFloat tmp = 44.0;
    if ( [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)] ) {
      tmp = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    }
    height += tmp;
    
  }
  
  [self insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
  
  CGFloat contentHeight = self.contentSize.height;
  CGFloat newContentHeight = contentHeight + height;
  CGFloat maxOffsetY = newContentHeight - self.height;
  if ( maxOffsetY<0.0 ) {
    maxOffsetY = 0.0;
  }
  CGFloat offsetY = offset.y + height;
  offset.y = MIN(offsetY, maxOffsetY);
  
  [self endUpdates];
  
  [UIView setAnimationsEnabled:YES];
  
  [self setContentOffset:offset animated:NO];
}


@end
