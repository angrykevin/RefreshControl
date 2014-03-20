//
//  TKNAIManager.h
//  TapKit
//
//  Created by Wu Kevin on 4/25/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Core/Core.h"
#import "../Additions/Additions.h"


@interface TKNAIManager : NSObject {
  NSMutableArray *_users;
  NSLock *_lock;
}


///-------------------------------
/// Singleton
///-------------------------------

+ (TKNAIManager *)sharedObject;


///-------------------------------
/// User routines
///-------------------------------

- (BOOL)isNetworkUser:(id)user;

- (void)addNetworkUser:(id)user;
- (void)removeNetworkUser:(id)user;
- (void)removeAllNetworkUsers;

@end
