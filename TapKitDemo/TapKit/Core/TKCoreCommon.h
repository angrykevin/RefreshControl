//
//  TKCoreCommon.h
//  TapKit
//
//  Created by Wu Kevin on 4/25/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif


///-------------------------------
/// Version
///-------------------------------

NSComparisonResult TKCompareVersion(NSString *version1, NSString *version2);

int TKMajorVersion(NSString *version);

int TKMinorVersion(NSString *version);

int TKBugfixVersion(NSString *version);


///-------------------------------
/// System paths
///-------------------------------

NSString *TKPathForBundleResource(NSBundle *bundle, NSString *relativePath);

NSString *TKPathForDocumentsResource(NSString *relativePath);

NSString *TKPathForLibraryResource(NSString *relativePath);

NSString *TKPathForCachesResource(NSString *relativePath);


///-------------------------------
/// Weak collections
///-------------------------------

NSMutableArray *TKCreateWeakMutableArray();

NSMutableDictionary *TKCreateWeakMutableDictionary();

NSMutableSet *TKCreateWeakMutableSet();


///-------------------------------
/// Object validity
///-------------------------------

BOOL TKIsInstance(id object, Class cls);


BOOL TKIsStringWithText(id object);

BOOL TKIsDataWithBytes(id object);

BOOL TKIsArrayWithItems(id object);

BOOL TKIsDictionaryWithItems(id object);

BOOL TKIsSetWithItems(id object);


///-------------------------------
/// Internet date
///-------------------------------

NSDateFormatter *TKInternetDateFormatter();

NSDate *TKDateFromInternetDateString(NSString *string);

NSString *TKInternetDateStringFromDate(NSDate *date);


#ifdef __cplusplus
}
#endif
