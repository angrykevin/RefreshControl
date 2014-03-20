//
//  NSDictionaryAdditions.m
//  TapKit
//
//  Created by Wu Kevin on 4/27/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "NSDictionaryAdditions.h"
#import "NSStringAdditions.h"

@implementation NSDictionary (TapKit)


#pragma mark - Querying

- (BOOL)hasObjectEqualTo:(id)object
{
  return ( [[self allValues] indexOfObject:object] != NSNotFound );
}

- (BOOL)hasObjectIdenticalTo:(id)object
{
  return ( [[self allValues] indexOfObjectIdenticalTo:object] != NSNotFound );
}

- (BOOL)hasKeyEqualTo:(id)key
{
  return ( [[self allKeys] indexOfObject:key] != NSNotFound );
}

- (BOOL)hasKeyIdenticalTo:(id)key
{
  return ( [[self allKeys] indexOfObjectIdenticalTo:key] != NSNotFound );
}

- (id)objectOrNilForKey:(id)key
{
  id object = [self objectForKey:key];
  if ( object != [NSNull null] ) {
    return object;
  }
  return nil;
}



#pragma mark - URL

- (NSString *)queryString
{
  NSMutableArray *pairs = [[NSMutableArray alloc] init];
  
  for ( NSString *key in [self keyEnumerator] ) {
    NSString *value = [[self objectForKey:key] URLEncodedString];
    NSString *pair = [NSString stringWithFormat:@"%@=%@", key, value];
    [pairs addObject:pair];
  }
  
  if ( [pairs count] > 0 ) {
    return [pairs componentsJoinedByString:@"&"];
  }
  
  return nil;
}

@end



@implementation NSMutableDictionary (TapKit)


#pragma mark - Adding and removing entries

- (void)setObject:(id)object forKeyIfNotNil:(id)key
{
  if ( object && key ) {
    [self setObject:object forKey:key];
  }
}

- (void)removeObjectForKeyIfNotNil:(id)key
{
  if ( key ) {
    [self removeObjectForKey:key];
  }
}

@end
