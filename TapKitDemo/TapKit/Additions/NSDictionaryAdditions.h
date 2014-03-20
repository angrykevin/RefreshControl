//
//  NSDictionaryAdditions.h
//  TapKit
//
//  Created by Wu Kevin on 4/27/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (TapKit)

///-------------------------------
/// Querying
///-------------------------------

- (BOOL)hasObjectEqualTo:(id)object;
- (BOOL)hasObjectIdenticalTo:(id)object;
- (BOOL)hasKeyEqualTo:(id)key;
- (BOOL)hasKeyIdenticalTo:(id)key;
- (id)objectOrNilForKey:(id)key;


///-------------------------------
/// URL
///-------------------------------

- (NSString *)queryString;

@end



@interface NSMutableDictionary (TapKit)

///-------------------------------
/// Adding and removing entries
///-------------------------------

- (void)setObject:(id)object forKeyIfNotNil:(id)key;
- (void)removeObjectForKeyIfNotNil:(id)key;

@end
