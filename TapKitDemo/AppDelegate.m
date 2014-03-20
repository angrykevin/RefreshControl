//
//  AppDelegate.m
//  TapKitDemo
//
//  Created by Wu Kevin on 4/11/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "AppDelegate.h"
#import "TTMainViewController.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  _window.rootViewController = [[TTMainViewController alloc] init];
  
  _window.backgroundColor = [UIColor whiteColor];
  [_window makeKeyAndVisible];
  return YES;
}

@end
