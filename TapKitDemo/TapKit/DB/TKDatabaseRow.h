//
//  TKDatabaseRow.h
//  TapKit
//
//  Created by Wu Kevin on 4/29/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Core/Core.h"
#import "../Additions/Additions.h"

@interface TKDatabaseRow : NSObject {
  NSArray *_names;
  NSArray *_types;
  NSArray *_columns;
}

@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) NSArray *columns;


///-------------------------------
/// Getting column value
///-------------------------------

- (BOOL)boolForName:(NSString *)name;
- (int)intForName:(NSString *)name;
- (long long)longLongForName:(NSString *)name;
- (double)doubleForName:(NSString *)name;
- (NSDate *)dateForName:(NSString *)name;
- (NSString *)stringForName:(NSString *)name;
- (NSData *)dataForName:(NSString *)name;


///-------------------------------
/// Getting values
///-------------------------------

- (NSDictionary *)columnDictionary;

@end
