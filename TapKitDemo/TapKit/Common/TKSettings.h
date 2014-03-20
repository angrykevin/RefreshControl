//
//  TKSettings.h
//  TapKit
//
//  Created by Wu Kevin on 4/29/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Core/Core.h"
#import "../Additions/Additions.h"

@interface TKSettings : NSObject {
  NSMutableDictionary *_settings;
  NSLock *_lock;
}


///-------------------------------
/// Singleton
///-------------------------------

+ (TKSettings *)sharedObject;


///-------------------------------
/// Accessing values
///-------------------------------

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;


///-------------------------------
/// Basic routines
///-------------------------------

- (NSArray *)keys;
- (void)synchronize;
- (void)dump;

@end
