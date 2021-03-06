//
//  TTMainViewController.m
//  TapKitDemo
//
//  Created by Wu Kevin on 5/17/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "TTMainViewController.h"
#import "UITableViewExtentions.h"

@implementation TTMainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _tableView = [[TBTableView alloc] init];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.showsRefreshControl = YES;
  [_tableView.refreshControl addTarget:self action:@selector(launchRefresh:) forControlEvents:UIControlEventValueChanged];
  _tableView.showsInfiniteRefreshControl = NO;
  [_tableView.infiniteRefreshControl addTarget:self action:@selector(launchInfiniteRefresh:) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:_tableView];
  
  _objectList = [[NSMutableArray alloc] init];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  UIButton *bt = [[UIButton alloc] init];
  [bt addTarget:self action:@selector(beginDown:) forControlEvents:UIControlEventTouchUpInside];
  [bt setTitle:@"开始下拉刷新" forState:UIControlStateNormal];
  bt.frame = CGRectMake(10.0, 30.0, 300.0, 40.0);
  [self.view addSubview:bt];
  [bt showBorderWithGreenColor];
  
  bt = [[UIButton alloc] init];
  [bt addTarget:self action:@selector(endDown:) forControlEvents:UIControlEventTouchUpInside];
  [bt setTitle:@"停止下拉刷新" forState:UIControlStateNormal];
  bt.frame = CGRectMake(10.0, 80.0, 300.0, 40.0);
  [self.view addSubview:bt];
  [bt showBorderWithRedColor];
  
  bt = [[UIButton alloc] init];
  [bt addTarget:self action:@selector(endUp:) forControlEvents:UIControlEventTouchUpInside];
  [bt setTitle:@"开始上拉刷新" forState:UIControlStateNormal];
  bt.frame = CGRectMake(10.0, self.view.height-100.0, 300.0, 40.0);
  [self.view addSubview:bt];
  [bt showBorderWithGreenColor];
  
  bt = [[UIButton alloc] init];
  [bt addTarget:self action:@selector(endUp:) forControlEvents:UIControlEventTouchUpInside];
  [bt setTitle:@"开始上拉刷新" forState:UIControlStateNormal];
  bt.frame = CGRectMake(10.0, self.view.height-50.0, 300.0, 40.0);
  [self.view addSubview:bt];
  [bt showBorderWithRedColor];
  
  
  NSString *time = [self loadTime];
  if ( time ) {
    NSAttributedString *info = [[NSAttributedString alloc] initWithString:time];
    _tableView.refreshControl.attributedTitle = info;
  }
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  _tableView.frame = self.view.bounds;
}



- (void)beginDown:(id)sender
{
  [_tableView startRefreshing:YES];
}

- (void)endDown:(id)sender
{
  [_tableView stopRefreshing:YES];
}

- (void)beginUp:(id)sender
{
  [_tableView startInfiniteRefreshing:YES];
}

- (void)endUp:(id)sender
{
  [_tableView stopInfiniteRefreshing:YES];
}



- (void)launchRefresh:(id)sender
{
  [self performSelector:@selector(doLoadPrev:) withObject:nil afterDelay:3.0];
}

- (void)doLoadPrev:(id)object
{
  NSDate *now = [NSDate date];
  
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"HH:mm"];
  NSString *prefix = [df stringFromDate:now];
  
  for ( int i=0; i<5; ++i ) {
    NSString *string = [NSString stringWithFormat:@"%@: %d", prefix, i+1];
    [_objectList insertObject:string atIndex:i];
  }
  
  [self saveTime:now];
  NSString *time = [self loadTime];
  if ( time ) {
    NSAttributedString *info = [[NSAttributedString alloc] initWithString:time];
    _tableView.refreshControl.attributedTitle = info;
  }
  
  [_tableView updateTableWithNewRowCount:5];
  //[_tableView reloadData];
  [_tableView.refreshControl endRefreshing];
  
  if ( !(_tableView.showsInfiniteRefreshControl) && (_tableView.contentSize.height>_tableView.height) ) {
    _tableView.showsInfiniteRefreshControl = YES;
    [_tableView.infiniteRefreshControl addTarget:self action:@selector(launchInfiniteRefresh:) forControlEvents:UIControlEventValueChanged];
  }
}

- (void)launchInfiniteRefresh:(id)sender
{
  [self performSelector:@selector(doLoadNext:) withObject:nil afterDelay:3.0];
}

- (void)doLoadNext:(id)object
{
  static int times = 0;
  times++;
  
  if ( times<4 ) {
    NSDate *now = [NSDate date];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    NSString *prefix = [df stringFromDate:now];
    
    for ( int i=0; i<5; ++i ) {
      NSString *string = [NSString stringWithFormat:@"%@: %d", prefix, i+1];
      [_objectList addObject:string];
    }
    
    [_tableView reloadData];
    [_tableView.infiniteRefreshControl endRefreshing];
  } else {
    [_tableView stopInfiniteRefreshingAndHide:YES];
  }
}




- (void)saveTime:(NSDate *)time
{
  [[TKSettings sharedObject] setObject:TKInternetDateStringFromDate(time)
                                forKey:@"RefreshTime"];
  [[TKSettings sharedObject] synchronize];
}

- (NSString *)loadTime
{
  NSDate *date = TKDateFromInternetDateString([[TKSettings sharedObject] objectForKey:@"RefreshTime"]);
  if ( date ) {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    return [df stringFromDate:date];
  }
  return nil;
}



//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//  int offsetY = scrollView.contentOffset.y;
//  int insetTop = scrollView.contentInset.top;
//  NSLog(@"offsetY: %d\t insetTop: %d", offsetY, insetTop);
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_objectList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithClass:[UITableViewCell class]];
  
  cell.textLabel.text = [_objectList objectOrNilAtIndex:indexPath.row];
  
  return cell;
}


@end
