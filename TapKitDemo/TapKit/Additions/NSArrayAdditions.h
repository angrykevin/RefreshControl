//
//  NSArrayAdditions.h
//  TapKit
//
//  Created by Wu Kevin on 4/27/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (TapKit)

///-------------------------------
/// Querying
///-------------------------------

- (id)objectOrNilAtIndex:(NSUInteger)idx;

- (id)firstObject;

- (id)randomObject;


- (BOOL)hasObjectEqualTo:(id)object;

- (BOOL)hasObjectIdenticalTo:(id)object;


///-------------------------------
/// Key-Value Coding
///-------------------------------

- (NSArray *)objectsForKeyPath:(NSString *)keyPath equalToValue:(id)value;

- (NSArray *)objectsForKeyPath:(NSString *)keyPath identicalToValue:(id)value;


- (id)firstObjectForKeyPath:(NSString *)keyPath equalToValue:(id)value;

- (id)firstObjectForKeyPath:(NSString *)keyPath identicalToValue:(id)value;

@end



@interface NSMutableArray (TapKit)

///-------------------------------
/// Adding and removing entries
///-------------------------------

- (id)addObjectIfNotNil:(id)object;

- (id)addUnequalObjectIfNotNil:(id)object;

- (id)addUnidenticalObjectIfNotNil:(id)object;


- (id)insertObject:(id)object atIndexIfNotNil:(NSUInteger)idx;


- (id)moveObjectAtIndex:(NSUInteger)idx toIndex:(NSUInteger)toIdx;


- (void)removeFirstObject;


///-------------------------------
/// Ordering and filtering
///-------------------------------

- (void)shuffle;

- (void)reverse;

- (void)unequal;

- (void)unidentical;


///-------------------------------
/// Stack
///-------------------------------

- (id)push:(id)object;

- (id)pop;


///-------------------------------
/// Queue
///-------------------------------

- (id)enqueue:(id)object;

- (id)dequeue;

@end
