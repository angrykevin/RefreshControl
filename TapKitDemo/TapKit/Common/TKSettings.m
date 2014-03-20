//
//  TKSettings.m
//  TapKit
//
//  Created by Wu Kevin on 4/29/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "TKSettings.h"

@implementation TKSettings


#pragma mark - NSObject

- (id)init
{
  self = [super init];
  if ( self ) {
    
    NSString *path = TKPathForDocumentsResource(@"AppSettings.xml");
    _settings = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if ( _settings == nil ) {
      _settings = [[NSMutableDictionary alloc] init];
    }
    
    _lock = [[NSLock alloc] init];
    
  }
  return self;
}



#pragma mark - Singleton

+ (TKSettings *)sharedObject
{
  static TKSettings *Settings = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    Settings = [[self alloc] init];
  });
  return Settings;
}



#pragma mark - Accessing values

- (id)objectForKey:(NSString *)key
{
  id object = nil;
  
  [_lock lock];
  object = [_settings objectForKey:key];
  [_lock unlock];
  
  return object;
}

- (void)setObject:(id)object forKey:(NSString *)key
{
  [_lock lock];
  
  if ( object ) {
    [_settings setObject:object forKeyIfNotNil:key];
  } else {
    [_settings removeObjectForKeyIfNotNil:key];
  }
  
  [_lock unlock];
}



#pragma mark - Basic routines

- (NSArray *)keys
{
  NSArray *keys = nil;
  
  [_lock lock];
  keys = [_settings allKeys];
  [_lock unlock];
  
  return keys;
}

- (void)synchronize
{
  [_lock lock];
  
  NSString *path = TKPathForDocumentsResource(@"AppSettings.xml");
  [_settings writeToFile:path atomically:YES];
  
  [_lock unlock];
}

- (void)dump
{
#ifdef DEBUG
  [_lock lock];
  NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
  NSLog(@"+");
  NSLog(@"+ total: %d", [_settings count]);
  NSLog(@"+");
  NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
  for ( NSString *key in [_settings keyEnumerator] ) {
    NSLog(@"+ %@ = %@", key, [_settings objectForKey:key]);
    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
  }
  [_lock unlock];
#endif
}

@end
