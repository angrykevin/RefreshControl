//
//  NSObjectAdditions.h
//  TapKit
//
//  Created by Wu Kevin on 4/26/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TapKit)

///-------------------------------
/// Class string
///-------------------------------

+ (NSString *)classString;

- (NSString *)classString;


///-------------------------------
/// Associate object
///-------------------------------

- (void)associateValue:(id)value withKey:(void *)key;

- (void)weaklyAssociateValue:(id)value withKey:(void *)key;

- (id)associatedValueForKey:(void *)key;


///-------------------------------
/// Key-Value Coding
///-------------------------------

- (BOOL)isValueForKeyPath:(NSString *)keyPath equalToValue:(id)value;

- (BOOL)isValueForKeyPath:(NSString *)keyPath identicalToValue:(id)value;

+ (NSDictionary *)propertyAttributes;

@end
