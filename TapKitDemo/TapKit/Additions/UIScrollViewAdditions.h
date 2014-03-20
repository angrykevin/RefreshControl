//
//  UIScrollViewAdditions.h
//  TapKit
//
//  Created by Wu Kevin on 5/13/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIScrollView (TapKit)

///-------------------------------
/// Content size
///-------------------------------

- (void)makeContentSizeToViewSize;
- (void)makeHorizontalScrollable;
- (void)makeVerticalScrollable;


///-------------------------------
/// Scrolling
///-------------------------------

- (void)scrollToTopAnimated:(BOOL)animated;
- (void)scrollToCenterAnimated:(BOOL)animated;
- (void)scrollToBottomAnimated:(BOOL)animated;
- (void)stopScrollingAnimated:(BOOL)animated;

@end
