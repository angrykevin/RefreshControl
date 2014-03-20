//
//  TKDatabaseRow.m
//  TapKit
//
//  Created by Wu Kevin on 4/29/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "TKDatabaseRow.h"

@implementation TKDatabaseRow


#pragma mark - Getting column value

- (BOOL)boolForName:(NSString *)name
{
  NSUInteger idx = [_names indexOfObject:name];
  id object = [_columns objectOrNilAtIndex:idx];
  if ( TKIsInstance(object, [NSNumber class]) ) {
    return ( [object intValue] != 0 );
  }
  return NO;
}

- (int)intForName:(NSString *)name
{
  NSUInteger idx = [_names indexOfObject:name];
  id object = [_columns objectOrNilAtIndex:idx];
  if ( TKIsInstance(object, [NSNumber class]) ) {
    return [object intValue];
  }
  return 0;
}

- (long long)longLongForName:(NSString *)name
{
  NSUInteger idx = [_names indexOfObject:name];
  id object = [_columns objectOrNilAtIndex:idx];
  if ( TKIsInstance(object, [NSNumber class]) ) {
    return [object longLongValue];
  }
  return 0;
}

- (double)doubleForName:(NSString *)name
{
  NSUInteger idx = [_names indexOfObject:name];
  id object = [_columns objectOrNilAtIndex:idx];
  if ( TKIsInstance(object, [NSNumber class]) ) {
    return [object doubleValue];
  }
  return 0.0;
}

- (NSDate *)dateForName:(NSString *)name
{
  NSUInteger idx = [_names indexOfObject:name];
  id object = [_columns objectOrNilAtIndex:idx];
  if ( TKIsInstance(object, [NSString class]) ) {
    return TKDateFromInternetDateString(object);
  }
  return nil;
}

- (NSString *)stringForName:(NSString *)name
{
  NSUInteger idx = [_names indexOfObject:name];
  id object = [_columns objectOrNilAtIndex:idx];
  if ( TKIsInstance(object, [NSString class]) ) {
    return object;
  }
  return nil;
}

- (NSData *)dataForName:(NSString *)name
{
  NSUInteger idx = [_names indexOfObject:name];
  id object = [_columns objectOrNilAtIndex:idx];
  if ( TKIsInstance(object, [NSData class]) ) {
    return object;
  }
  return nil;
}



#pragma mark - Getting values

- (NSDictionary *)columnDictionary
{
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
  
  for ( int i=0; i<[_names count]; ++i ) {
    NSString *name = [_names objectOrNilAtIndex:i];
    id column = [_columns objectOrNilAtIndex:i];
    if ( column != [NSNull null] ) {
      [dictionary setObject:column forKeyIfNotNil:name];
    }
  }
  
  if ( [dictionary count] > 0 ) {
    return dictionary;
  }
  
  return nil;
}

@end
