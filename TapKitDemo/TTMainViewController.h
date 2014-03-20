//
//  TTMainViewController.h
//  TapKitDemo
//
//  Created by Wu Kevin on 5/17/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBTableView.h"

@interface TTMainViewController : UIViewController<
    UITableViewDataSource,
    UITableViewDelegate
> {
  
  TBTableView *_tableView;
  NSMutableArray *_objectList;
  
}

@end
