//
//  TKDatabase.h
//  TapKit
//
//  Created by Wu Kevin on 4/29/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "../Core/Core.h"
#import "../Additions/Additions.h"

#import "TKDatabaseRow.h"

@interface TKDatabase : NSObject {
  NSString *_path;
  
  sqlite3 *_handle;
  
  BOOL _opened;
  BOOL _inTransaction;
  
  NSLock *_lock;
}

@property (nonatomic, copy) NSString *path;

@property (nonatomic, assign) sqlite3 *handle;


///-------------------------------
/// Singleton
///-------------------------------

+ (TKDatabase *)sharedObject;


///-------------------------------
/// Sqlite connection
///-------------------------------

- (BOOL)open;
- (void)close;


///-------------------------------
/// Database routines
///-------------------------------

- (BOOL)hasTableNamed:(NSString *)name;
- (BOOL)hasRowForSQLStatement:(NSString *)sql;

- (BOOL)executeUpdate:(NSString *)sql, ...;
- (BOOL)executeUpdate:(NSString *)sql parameters:(NSArray *)parameters;

- (NSArray *)executeQuery:(NSString *)sql, ...;
- (NSArray *)executeQuery:(NSString *)sql parameters:(NSArray *)parameters;


///-------------------------------
/// Transactions
///-------------------------------

- (BOOL)beginTransaction;
- (BOOL)commitTransaction;
- (BOOL)rollbackTransaction;
- (BOOL)inTransaction;


///-------------------------------
/// Error infomation
///-------------------------------

- (NSString *)lastErrorMessage;
- (int)lastErrorCode;
- (BOOL)hadError;

@end
