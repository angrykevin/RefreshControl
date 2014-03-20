//
//  UITableViewAdditions.h
//  TapKit
//
//  Created by Wu Kevin on 5/13/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableView (TapKit)

///-------------------------------
/// Querying
///-------------------------------

- (UITableViewCell *)dequeueReusableCellWithClass:(Class)cls;


///-------------------------------
/// Selection
///-------------------------------

- (void)deselectAllRowsAnimated:(BOOL)animated;

@end


@interface UITableViewCell (TapKit)

///-------------------------------
/// Cell height
///-------------------------------

+ (CGFloat)heightForTableView:(UITableView *)tableView object:(id)object;

@end
