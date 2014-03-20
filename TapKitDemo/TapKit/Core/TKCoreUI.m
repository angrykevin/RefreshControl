//
//  TKCoreUI.m
//  TapKit
//
//  Created by Wu Kevin on 4/26/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "TKCoreUI.h"



#pragma mark - Autoresizing mask

const NSUInteger TKViewAutoresizingKeepSize =
                      UIViewAutoresizingFlexibleLeftMargin
                    | UIViewAutoresizingFlexibleTopMargin
                    | UIViewAutoresizingFlexibleRightMargin
                    | UIViewAutoresizingFlexibleBottomMargin
                    | !UIViewAutoresizingFlexibleWidth
                    | !UIViewAutoresizingFlexibleHeight;

const NSUInteger TKViewAutoresizingKeepMargin =
                      !UIViewAutoresizingFlexibleLeftMargin
                    | !UIViewAutoresizingFlexibleTopMargin
                    | !UIViewAutoresizingFlexibleRightMargin
                    | !UIViewAutoresizingFlexibleBottomMargin
                    | UIViewAutoresizingFlexibleWidth
                    | UIViewAutoresizingFlexibleHeight;



#pragma mark - Image name

NSString *TKDeviceSpecificImageName(NSString *name)
{
  if ( [UIScreen mainScreen].scale == 2.0 ) {
    
    NSString *extension = [name pathExtension];
    
    NSRange range = [name rangeOfString:@"."];
    NSString *body = [name substringToIndex:range.location];
    
    NSMutableString *final = [[NSMutableString alloc] initWithString:body];
    
    if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        && ([UIScreen mainScreen].bounds.size.height > 480.0))
    {
      [final appendString:@"-568h"];
    }
    
    [final appendString:@"@2x"];
    [final appendFormat:@".%@", extension];
    
    return final;
  }
  return name;
}



#pragma mark - Keyboard

BOOL TKIsKeyboardVisible()
{
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  UIView *firstResponder = TKFindFirstResponderInView(window);
  return ( firstResponder != nil );
}

UIView *TKFindFirstResponderInView(UIView *topView)
{
  if ( [topView isFirstResponder] ) {
    return topView;
  }
  
  for ( UIView *subview in topView.subviews ) {
    if ( [subview isFirstResponder] ) {
      return subview;
    }
    
    UIView *firstResponder = TKFindFirstResponderInView(subview);
    if ( firstResponder ) {
      return firstResponder;
    }
  }
  return nil;
}



#pragma mark - Orientation

UIDeviceOrientation TKDeviceOrientation()
{
  return [UIDevice currentDevice].orientation;
}

UIInterfaceOrientation TKInterfaceOrientation()
{
  return [UIApplication sharedApplication].statusBarOrientation;
}


BOOL TKIsDevicePortrait()
{
  UIDeviceOrientation orientation = TKDeviceOrientation();
  return ((orientation == UIDeviceOrientationPortrait)
          || (orientation == UIDeviceOrientationPortraitUpsideDown)
          );
}

BOOL TKIsDeviceLandscape()
{
  UIDeviceOrientation orientation = TKDeviceOrientation();
  return ((orientation == UIDeviceOrientationLandscapeLeft)
          || (orientation == UIDeviceOrientationLandscapeRight)
          );
}

BOOL TKIsInterfacePortrait()
{
  UIInterfaceOrientation orientation = TKInterfaceOrientation();
  return ((orientation == UIInterfaceOrientationPortrait)
          || (orientation == UIInterfaceOrientationPortraitUpsideDown)
          );
}

BOOL TKIsInterfaceLandscape()
{
  UIInterfaceOrientation orientation = TKInterfaceOrientation();
  return ((orientation == UIInterfaceOrientationLandscapeLeft)
          || (orientation == UIInterfaceOrientationLandscapeRight)
          );
}


BOOL TKIsSupportedOrientation(UIInterfaceOrientation orientation)
{
  if ( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
    return YES;
  }
  
  if ((orientation == UIInterfaceOrientationPortrait)
      || (orientation == UIInterfaceOrientationLandscapeLeft)
      || (orientation == UIInterfaceOrientationLandscapeRight))
  {
    return YES;
  }
  
  return NO;
}

CGAffineTransform TKRotateTransformForOrientation(UIInterfaceOrientation orientation)
{
  if ( orientation == UIInterfaceOrientationLandscapeLeft ) {
    
    return CGAffineTransformMakeRotation(M_PI * 1.5);
    
  } else if ( orientation == UIInterfaceOrientationLandscapeRight ) {
    
    return CGAffineTransformMakeRotation(M_PI / 2.0);
    
  } else if ( orientation == UIInterfaceOrientationPortraitUpsideDown ) {
    
    return CGAffineTransformMakeRotation(0.0 - M_PI);
    
  }
  return CGAffineTransformIdentity;
}

CGAffineTransform TKSupportedRotateTransformForOrientation(UIInterfaceOrientation orientation)
{
  if ( orientation == UIInterfaceOrientationLandscapeLeft ) {
    
    return CGAffineTransformMakeRotation(M_PI * 1.5);
    
  } else if ( orientation == UIInterfaceOrientationLandscapeRight ) {
    
    return CGAffineTransformMakeRotation(M_PI / 2.0);
    
  }
  return CGAffineTransformIdentity;
}
