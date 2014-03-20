//
//  TKCoreCompatibility.m
//  TapKit
//
//  Created by Wu Kevin on 4/25/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "TKCoreCompatibility.h"
#include <sys/sysctl.h>



#pragma mark - Device compatibility

NSString *TKDevicePlatform()
{
  char buffer[128];
  bzero(buffer, 128);
  
  size_t size = 128;
  
  sysctlbyname("hw.machine", buffer, &size, NULL, 0);
  
  return [[NSString alloc] initWithCString:buffer encoding:NSUTF8StringEncoding];
}

NSString *TKDeviceModel()
{
  NSString *platform = TKDevicePlatform();
  
  if ( [platform isEqualToString:@"iPhone1,1"] ) return @"iPhone 2G";
  if ( [platform isEqualToString:@"iPhone1,2"] ) return @"iPhone 3G";
  if ( [platform isEqualToString:@"iPhone2,1"] ) return @"iPhone 3GS";
  if ( [platform isEqualToString:@"iPhone3,1"] ) return @"iPhone 4";
  if ( [platform isEqualToString:@"iPhone3,2"] ) return @"iPhone 4";
  if ( [platform isEqualToString:@"iPhone3,3"] ) return @"iPhone 4";
  if ( [platform isEqualToString:@"iPhone4,1"] ) return @"iPhone 4S";
  if ( [platform isEqualToString:@"iPhone5,1"] ) return @"iPhone 5";
  if ( [platform isEqualToString:@"iPhone5,2"] ) return @"iPhone 5";
  if ( [platform isEqualToString:@"iPhone5,3"] ) return @"iPhone 5C";
  if ( [platform isEqualToString:@"iPhone5,4"] ) return @"iPhone 5C";
  if ( [platform isEqualToString:@"iPhone6,1"] ) return @"iPhone 5S";
  if ( [platform isEqualToString:@"iPhone6,2"] ) return @"iPhone 5S";
  
  if ( [platform isEqualToString:@"iPod1,1"] ) return @"iPod touch 1G";
  if ( [platform isEqualToString:@"iPod2,1"] ) return @"iPod touch 2G";
  if ( [platform isEqualToString:@"iPod3,1"] ) return @"iPod touch 3G";
  if ( [platform isEqualToString:@"iPod4,1"] ) return @"iPod touch 4G";
  if ( [platform isEqualToString:@"iPod5,1"] ) return @"iPod touch 5G";
  
  if ( [platform isEqualToString:@"iPad1,1"] ) return @"iPad 1G";
  if ( [platform isEqualToString:@"iPad2,1"] ) return @"iPad 2";
  if ( [platform isEqualToString:@"iPad2,2"] ) return @"iPad 2";
  if ( [platform isEqualToString:@"iPad2,3"] ) return @"iPad 2";
  if ( [platform isEqualToString:@"iPad2,4"] ) return @"iPad 2";
  if ( [platform isEqualToString:@"iPad2,5"] ) return @"iPad mini 1G";
  if ( [platform isEqualToString:@"iPad2,6"] ) return @"iPad mini 1G";
  if ( [platform isEqualToString:@"iPad2,7"] ) return @"iPad mini 1G";
  if ( [platform isEqualToString:@"iPad3,1"] ) return @"iPad 3";
  if ( [platform isEqualToString:@"iPad3,2"] ) return @"iPad 3";
  if ( [platform isEqualToString:@"iPad3,3"] ) return @"iPad 3";
  if ( [platform isEqualToString:@"iPad3,4"] ) return @"iPad 4";
  if ( [platform isEqualToString:@"iPad3,5"] ) return @"iPad 4";
  if ( [platform isEqualToString:@"iPad3,6"] ) return @"iPad 4";
  if ( [platform isEqualToString:@"iPad4,1"] ) return @"iPad Air";
  if ( [platform isEqualToString:@"iPad4,2"] ) return @"iPad Air";
  if ( [platform isEqualToString:@"iPad4,4"] ) return @"iPad mini 2G";
  if ( [platform isEqualToString:@"iPad4,5"] ) return @"iPad mini 2G";
  
  return nil;
}

NSString *TKDeviceFamily()
{
  NSString *platform = TKDevicePlatform();
  
  if ( [platform hasPrefix:@"iPhone"] ) return @"iPhone";
  if ( [platform hasPrefix:@"iPod"] ) return @"iPod";
  if ( [platform hasPrefix:@"iPad"] ) return @"iPad";
  
  return nil;
}



#pragma mark - SDK compatibility

BOOL TKIsRetina()
{
  UIScreen *screen = [UIScreen mainScreen];
  return ( screen.scale == 2.0 );
}

BOOL TKIsPad()
{
  UIDevice *device = [UIDevice currentDevice];
  return ( device.userInterfaceIdiom == UIUserInterfaceIdiomPad );
}

BOOL TKIsPhone()
{
  UIDevice *device = [UIDevice currentDevice];
  return ( device.userInterfaceIdiom == UIUserInterfaceIdiomPhone );
}

CGFloat TKSystemVersion()
{
  return [[[UIDevice currentDevice] systemVersion] floatValue];
}
