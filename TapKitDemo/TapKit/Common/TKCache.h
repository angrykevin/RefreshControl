//
//  TKCache.h
//  TapKit
//
//  Created by Wu Kevin on 5/14/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Core/Core.h"
#import "../Additions/Additions.h"


@class TKCacheItem;

@interface TKCache : NSObject {
  NSMutableArray *_items;
  NSLock *_lock;
}


///-------------------------------
/// Singleton
///-------------------------------

+ (TKCache *)sharedObject;


///-------------------------------
/// Accessing caches
///-------------------------------

- (void)addCacheItem:(TKCacheItem *)item;
- (NSData *)dataForKey:(NSString *)key;
- (BOOL)setData:(NSData *)data forKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (BOOL)hasCacheForKey:(NSString *)key;
- (void)removeCacheForKey:(NSString *)key;


///-------------------------------
/// Basic routines
///-------------------------------

- (NSUInteger)count;
- (void)clear;
- (void)cleanUp;
- (int)cacheSize;
- (void)synchronize;


///-------------------------------
/// Paths
///-------------------------------

- (NSString *)cacheRootDirectory;
- (NSString *)cachePathForKey:(NSString *)key;

@end



@interface TKCacheItem : NSObject<NSCoding> {
  NSString *_key;
  NSString *_path;
  NSDate *_expiryDate;
  int _size;
}

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSDate *expiryDate;
@property (nonatomic, assign) int size;

@end
