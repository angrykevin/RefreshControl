//
//  TKCoreBase64.h
//  TapKit
//
//  Created by Wu Kevin on 4/27/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif


///-------------------------------
/// Base64 encoding
///-------------------------------

NSString *TKEncodeBase64(NSData *data);

NSData *TKDecodeBase64(NSString *string);


#ifdef __cplusplus
}
#endif
