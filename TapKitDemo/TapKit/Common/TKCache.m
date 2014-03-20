//
//  TKCache.m
//  TapKit
//
//  Created by Wu Kevin on 5/14/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "TKCache.h"

@implementation TKCache


#pragma mark - NSObject

- (id)init
{
  self = [super init];
  if ( self ) {
    
    NSString *cacheRoot = TKPathForDocumentsResource(@"Caches");
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:cacheRoot isDirectory:NULL] ) {
      [[NSFileManager defaultManager] createDirectoryAtPath:cacheRoot
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:NULL];
    }
    
    
    _items = [[NSMutableArray alloc] init];
    
    NSString *path = TKPathForDocumentsResource(@"Caches/profile.dt");
    NSArray *items = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    for ( TKCacheItem *item in items ) {
      if ( [item.expiryDate earlierThan:[NSDate date]] ) {
        [[NSFileManager defaultManager] removeItemAtPath:item.path error:NULL];
      } else {
        [_items addObject:item];
      }
    }
    
    
    _lock = [[NSLock alloc] init];
    
  }
  return self;
}



#pragma mark - Singleton

+ (TKCache *)sharedObject
{
  static TKCache *Cache = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    Cache = [[self alloc] init];
  });
  return Cache;
}



#pragma mark - Accessing caches

- (void)addCacheItem:(TKCacheItem *)item
{
  if ( item ) {
    if ( [item.key length] <= 0 ) {
      return;
    }
    
    NSString *path = [[NSString alloc] initWithFormat:@"Caches/%@", item.key];
    if ( ![TKPathForDocumentsResource(path) isEqualToString:item.path] ) {
      return;
    }
    
    if ( item.expiryDate == nil ) {
      return;
    }
    
    if ( [item.expiryDate earlierThan:[NSDate date]] ) {
      return;
    }
    
    [_lock lock];
    [_items addObject:item];
    [_lock unlock];
  }
}

- (NSData *)dataForKey:(NSString *)key
{
  NSData *data = nil;
  
  if ( [key length] > 0 ) {
    [_lock lock];
    TKCacheItem *item = [_items firstObjectForKeyPath:@"key" equalToValue:key];
    if ( item ) {
      if ( ![item.expiryDate earlierThan:[NSDate date]] ) {
        data = [[NSData alloc] initWithContentsOfFile:item.path];
      }
    }
    [_lock unlock];
  }
  
  return data;
}

- (BOOL)setData:(NSData *)data forKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval
{
  BOOL result = NO;
  
  if ( [key length] > 0 ) {
    [_lock lock];
    
    TKCacheItem *item = [_items firstObjectForKeyPath:@"key" equalToValue:key];
    if ( item == nil ) {
      item = [[TKCacheItem alloc] init];
      [_items addObject:item];
    }
    
    item.key = key;
    
    NSString *path = [[NSString alloc] initWithFormat:@"Caches/%@", key];
    item.path = TKPathForDocumentsResource(path);
    
    NSTimeInterval interval = (timeoutInterval > 0) ? timeoutInterval : TKTimeIntervalWeek();
    item.expiryDate = [[NSDate alloc] initWithTimeIntervalSinceNow:interval];
    
    item.size = [data length];
    
    if ( data ) {
      [data writeToFile:item.path atomically:YES];
    } else {
      [[NSFileManager defaultManager] removeItemAtPath:item.path error:NULL];
    }
    
    result = YES;
    
    [_lock unlock];
  }
  
  return result;
}


- (BOOL)hasCacheForKey:(NSString *)key
{
  BOOL result = NO;
  
  if ( [key length] > 0 ) {
    [_lock lock];
    TKCacheItem *item = [_items firstObjectForKeyPath:@"key" equalToValue:key];
    if ( item ) {
      result = ( ![item.expiryDate earlierThan:[NSDate date]] );
    }
    [_lock unlock];
  }
  
  return result;
}

- (void)removeCacheForKey:(NSString *)key
{
  if ( [key length] > 0 ) {
    [_lock lock];
    TKCacheItem *item = [_items firstObjectForKeyPath:@"key" equalToValue:key];
    if ( item ) {
      [_items removeObjectIdenticalTo:item];
      [[NSFileManager defaultManager] removeItemAtPath:item.path error:NULL];
    }
    [_lock unlock];
  }
}



#pragma mark - Basic routines

- (NSUInteger)count
{
  NSUInteger amount = 0;
  
  [_lock lock];
  amount = [_items count];
  [_lock unlock];
  
  return amount;
}

- (void)clear
{
  [_lock lock];
  
  [_items removeAllObjects];
  
  
  NSString *cacheRoot = TKPathForDocumentsResource(@"Caches");
  
  [[NSFileManager defaultManager] removeItemAtPath:cacheRoot error:NULL];
  
  if ( ![[NSFileManager defaultManager] fileExistsAtPath:cacheRoot isDirectory:NULL] ) {
    [[NSFileManager defaultManager] createDirectoryAtPath:cacheRoot
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
  }
  
  [_lock unlock];
}

- (void)cleanUp
{
  [_lock lock];
  
  NSMutableArray *items = [[NSMutableArray alloc] init];
  for ( TKCacheItem *item in _items ) {
    if ( [item.expiryDate earlierThan:[NSDate date]] ) {
      [[NSFileManager defaultManager] removeItemAtPath:item.path error:NULL];
    } else {
      [items addObject:item];
    }
  }
  
  _items = items;
  
  [_lock unlock];
}

- (int)cacheSize
{
  int size = 0;
  
  [_lock lock];
  for ( TKCacheItem *item in _items ) {
    size += item.size;
  }
  [_lock unlock];
  
  return size;
}

- (void)synchronize
{
  [_lock lock];
  
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_items];
  NSString *path = TKPathForDocumentsResource(@"Caches/profile.dt");
  [data writeToFile:path atomically:YES];
  
  [_lock unlock];
}



#pragma mark - Paths

- (NSString *)cacheRootDirectory
{
  return TKPathForDocumentsResource(@"Caches");
}

- (NSString *)cachePathForKey:(NSString *)key
{
  if ( [key length] > 0 ) {
    NSString *path = [[NSString alloc] initWithFormat:@"Caches/%@", key];
    return TKPathForDocumentsResource(path);
  }
  return nil;
}

@end



@implementation TKCacheItem

@synthesize key = _key;
@synthesize path = _path;
@synthesize expiryDate = _expiryDate;
@synthesize size = _size;

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if ( self ) {
    _key = [decoder decodeObjectForKey:@"kKey"];
    _path = [decoder decodeObjectForKey:@"kPath"];
    _expiryDate = [decoder decodeObjectForKey:@"kExpiryDate"];
    _size = [decoder decodeIntForKey:@"kSize"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:_key forKey:@"kKey"];
  [encoder encodeObject:_path forKey:@"kPath"];
  [encoder encodeObject:_expiryDate forKey:@"kExpiryDate"];
  [encoder encodeInt:_size forKey:@"kSize"];
}

@end
