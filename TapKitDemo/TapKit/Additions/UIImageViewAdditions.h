//
//  UIImageViewAdditions.h
//  TapKit
//
//  Created by Wu Kevin on 5/13/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (TapKit)

///-------------------------------
/// Load image
///-------------------------------

- (void)loadImageNamed:(NSString *)name;
- (void)loadImageNamed:(NSString *)name shouldCache:(BOOL)shouldCache;

@end
