//
//  TKDebug.h
//  TapKit
//
//  Created by Wu Kevin on 4/26/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#ifdef __cplusplus
extern "C" {
#endif


#ifdef DEBUG
#define TKPRINT(__fmt, ...) NSLog(@"%s: "__fmt, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define TKPRINT(__fmt, ...) ((void)0)
#endif // #ifdef DEBUG


#ifdef DEBUG
#define TKPRINTMETHOD() NSLog(@"%s", __PRETTY_FUNCTION__)
#else
#define TKPRINTMETHOD() ((void)0)
#endif // #ifdef DEBUG


#ifdef DEBUG
#define TKTESTVALUE(__value, __info) NSLog(@"%s: %@ is %@", __PRETTY_FUNCTION__, __info, (__value) ? @"YES" : @"NO")
#else
#define TKTESTVALUE(__value, __info) ((void)0)
#endif // #ifdef DEBUG


#ifdef __cplusplus
}
#endif
