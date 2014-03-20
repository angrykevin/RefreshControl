//
//  TKOperation.m
//  TapKit
//
//  Created by Wu Kevin on 4/28/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "TKOperation.h"

@implementation TKOperation


#pragma mark - NSOperation

- (void)cancel
{
  if ( [self isCancelled] ) {
    return;
  }
  
  if ( [self isFinished] ) {
    return;
  }
  
  [self transferStatusToCancelled];
  
  [super cancel];
}

- (BOOL)isReady
{
  return ( (_ready) && [super isReady] );
}

- (BOOL)isExecuting
{
  return ( _executing );
}

- (BOOL)isFinished
{
  return ( _finished );
}

- (BOOL)isCancelled
{
  return _cancelled;
}

- (BOOL)isConcurrent
{
  return YES;
}



#pragma mark - Status transfer

- (void)transferStatusToReady
{
  [self willChangeValueForKey:@"isReady"];
  _ready = YES;
  [self didChangeValueForKey:@"isReady"];
}

- (void)transferStatusToCancelled
{
  [self willChangeValueForKey:@"isCancelled"];
  _cancelled = YES;
  [self didChangeValueForKey:@"isCancelled"];
}

- (void)transferStatusToFinished
{
  [self willChangeValueForKey:@"isFinished"];
  _finished = YES;
  [self didChangeValueForKey:@"isFinished"];
}

- (void)transferStatusFromReadyToExecuting
{
  [self willChangeValueForKey:@"isExecuting"];
  [self willChangeValueForKey:@"isReady"];
  _ready = NO;
  _executing = YES;
  [self didChangeValueForKey:@"isReady"];
  [self didChangeValueForKey:@"isExecuting"];
}

- (void)transferStatusFromExecutingToFinished
{
  [self willChangeValueForKey:@"isFinished"];
  [self willChangeValueForKey:@"isExecuting"];
  _executing = NO;
  _finished = YES;
  [self didChangeValueForKey:@"isExecuting"];
  [self didChangeValueForKey:@"isFinished"];
}



#pragma mark - Notify routines

- (void)notifyObserversOperationDidStart
{
  if ( _notifyOnMainThread ) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
      if ( _didStartBlock ) {
        _didStartBlock(self);
      }
      for ( id object in _observers ) {
        if ( [object respondsToSelector:@selector(operationDidStart:)] ) {
          [object operationDidStart:self];
        }
      }
    });
    
  } else {
    
    if ( _didStartBlock ) {
      _didStartBlock(self);
    }
    for ( id object in _observers ) {
      if ( [object respondsToSelector:@selector(operationDidStart:)] ) {
        [object operationDidStart:self];
      }
    }
    
  }
}

- (void)notifyObserversOperationDidUpdate
{
  if ( _notifyOnMainThread ) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
      if ( _didUpdateBlock ) {
        _didUpdateBlock(self);
      }
      for ( id object in _observers ) {
        if ( [object respondsToSelector:@selector(operationDidUpdate:)] ) {
          [object operationDidUpdate:self];
        }
      }
    });
    
  } else {
    
    if ( _didUpdateBlock ) {
      _didUpdateBlock(self);
    }
    for ( id object in _observers ) {
      if ( [object respondsToSelector:@selector(operationDidUpdate:)] ) {
        [object operationDidUpdate:self];
      }
    }
    
  }
}

- (void)notifyObserversOperationDidFail
{
  if ( _notifyOnMainThread ) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
      if ( _didFailBlock ) {
        _didFailBlock(self);
      }
      for ( id object in _observers ) {
        if ( [object respondsToSelector:@selector(operationDidFail:)] ) {
          [object operationDidFail:self];
        }
      }
    });
    
  } else {
    
    if ( _didFailBlock ) {
      _didFailBlock(self);
    }
    for ( id object in _observers ) {
      if ( [object respondsToSelector:@selector(operationDidFail:)] ) {
        [object operationDidFail:self];
      }
    }
    
  }
}

- (void)notifyObserversOperationDidFinish
{
  if ( _notifyOnMainThread ) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
      if ( _didFinishBlock ) {
        _didFinishBlock(self);
      }
      for ( id object in _observers ) {
        if ( [object respondsToSelector:@selector(operationDidFinish:)] ) {
          [object operationDidFinish:self];
        }
      }
    });
    
  } else {
    
    if ( _didFinishBlock ) {
      _didFinishBlock(self);
    }
    for ( id object in _observers ) {
      if ( [object respondsToSelector:@selector(operationDidFinish:)] ) {
        [object operationDidFinish:self];
      }
    }
    
  }
}



#pragma mark - TKObserverProtocol

- (NSArray *)observers
{
  if ( _observers == nil ) {
    _observers = TKCreateWeakMutableArray();
  }
  return _observers;
}

- (id)addObserver:(id)observer
{
  if ( _observers == nil ) {
    _observers = TKCreateWeakMutableArray();
  }
  return [_observers addUnidenticalObjectIfNotNil:observer];
}

- (void)removeObserver:(id)observer
{
  [_observers removeObjectIdenticalTo:observer];
}

- (void)removeAllObservers
{
  [_observers removeAllObjects];
}

@end
