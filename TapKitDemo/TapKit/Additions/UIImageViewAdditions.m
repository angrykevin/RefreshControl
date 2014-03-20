//
//  UIImageViewAdditions.m
//  TapKit
//
//  Created by Wu Kevin on 5/13/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "UIImageViewAdditions.h"

@implementation UIImageView (TapKit)


#pragma mark - Load image

- (void)loadImageNamed:(NSString *)name
{
  [self loadImageNamed:name shouldCache:NO];
}

- (void)loadImageNamed:(NSString *)name shouldCache:(BOOL)shouldCache
{
  UIImage *newImage = nil;
  if ( shouldCache ) {
    newImage = [UIImage imageNamed:name];
  } else {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *path = [resourcePath stringByAppendingPathComponent:name];
    newImage = [[UIImage alloc] initWithContentsOfFile:path];
  }
  self.image = newImage;
}

@end
