//
//  TKNAIManager.m
//  TapKit
//
//  Created by Wu Kevin on 4/25/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "TKNAIManager.h"


@implementation TKNAIManager


#pragma mark - NSObject

- (id)init
{
  self = [super init];
  if ( self ) {
    
    _users = TKCreateWeakMutableArray();
    
    _lock = [[NSLock alloc] init];
    
  }
  return self;
}



#pragma mark - Singleton

+ (TKNAIManager *)sharedObject
{
  static TKNAIManager *NAIManager = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    NAIManager = [[self alloc] init];
  });
  return NAIManager;
}



#pragma mark - User routines

- (BOOL)isNetworkUser:(id)user
{
  BOOL result = NO;
  
  [_lock lock];
  result = [_users hasObjectIdenticalTo:user];
  [_lock unlock];
  
  return result;
}


- (void)addNetworkUser:(id)user
{
  [_lock lock];
  
  [_users addUnidenticalObjectIfNotNil:user];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = TKIsArrayWithItems(_users);
  
  [_lock unlock];
}

- (void)removeNetworkUser:(id)user
{
  [_lock lock];
  
  [_users removeObjectIdenticalTo:user];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = TKIsArrayWithItems(_users);
  
  [_lock unlock];
}

- (void)removeAllNetworkUsers
{
  [_lock lock];
  
  [_users removeAllObjects];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  
  [_lock unlock];
}

@end
