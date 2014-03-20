//
//  TKObserverProtocol.h
//  TapKit
//
//  Created by Wu Kevin on 4/28/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TKObserverProtocol <NSObject>

- (NSArray *)observers;
- (id)addObserver:(id)observer;
- (void)removeObserver:(id)observer;
- (void)removeAllObservers;

@end
