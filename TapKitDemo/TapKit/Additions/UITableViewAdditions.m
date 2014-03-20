//
//  UITableViewAdditions.m
//  TapKit
//
//  Created by Wu Kevin on 5/13/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "UITableViewAdditions.h"

@implementation UITableView (TapKit)


#pragma mark - Querying

- (UITableViewCell *)dequeueReusableCellWithClass:(Class)cls
{
  if ( cls ) {
    
    NSString *identifier = NSStringFromClass(cls);
    
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    
    if ( cell == nil ) {
      cell = [[cls alloc] init];
    }
    
    return cell;
  }
  
  return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
}



#pragma mark - Selection

- (void)deselectAllRowsAnimated:(BOOL)animated
{
  NSArray *ips = [self indexPathsForSelectedRows];
  for ( NSIndexPath *ip in ips ) {
    [self deselectRowAtIndexPath:ip animated:animated];
  }
}

@end



@implementation UITableViewCell (Tint)


#pragma mark - Cell height

+ (CGFloat)heightForTableView:(UITableView *)tableView object:(id)object
{
  return 44.0;
}

@end
