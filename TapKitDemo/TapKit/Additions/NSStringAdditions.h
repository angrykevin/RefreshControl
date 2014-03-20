//
//  NSStringAdditions.h
//  TapKit
//
//  Created by Wu Kevin on 4/27/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TapKit)

///-------------------------------
/// UUID
///-------------------------------

+ (NSString *)UUIDString;


///-------------------------------
/// Validity
///-------------------------------

- (BOOL)isDecimalNumber;

- (BOOL)isWhitespaceAndNewline;


- (BOOL)isInCharacterSet:(NSCharacterSet *)characterSet;


///-------------------------------
/// Hash
///-------------------------------

- (NSString *)MD5HashString;

- (NSString *)SHA1HashString;


///-------------------------------
/// URL
///-------------------------------

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (NSDictionary *)queryDictionary;
- (NSString *)stringByAddingQueryDictionary:(NSDictionary *)dictionary;
- (NSString *)stringByAppendingValue:(NSString *)value forKey:(NSString *)key;


///-------------------------------
/// MIME types
///-------------------------------

- (NSString *)MIMEType;

@end
