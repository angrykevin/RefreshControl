//
//  TKURLConnectionOperation.m
//  TapKit
//
//  Created by Wu Kevin on 5/21/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "TKURLConnectionOperation.h"
#import "TKNAIManager.h"


@implementation TKURLConnectionOperation


#pragma mark - Initializing

- (id)initWithAddress:(NSString *)address
      timeoutInterval:(NSTimeInterval)timeoutInterval
          cachePolicy:(NSURLRequestCachePolicy)cachePolicy
{
  self = [super init];
  if ( self ) {
    
    _address = address;
    _timeoutInterval = (timeoutInterval > 0.0) ? timeoutInterval : 10.0;
    _cachePolicy = (cachePolicy == 0) ? NSURLRequestUseProtocolCachePolicy : cachePolicy;
    _method = @"GET";
    _headers = [[NSMutableDictionary alloc] init];
    //_body = nil;
    //_formFields = nil;
    
    //_request = nil;
    
    //_response = nil;
    //_responseData = nil;
    //_responseFilePath = nil;
    //_responseFileHandle = nil;
    
    _shouldUpdateNetworkActivityIndicator = YES;
    
    _runLoopMode = NSRunLoopCommonModes;
    
    //_connection = nil;
    
    //_bytesWritten = 0;
    //_totalBytesWritten = 0;
    //_totalBytesExpectedToWrite = 0;
    
    //_bytesRead = 0;
    //_totalBytesRead = 0;
    //_totalBytesExpectedToRead = 0;
    
    
    [self transferStatusToReady];
  }
  return self;
}

- (id)initWithRequest:(NSURLRequest *)request
{
  self = [super init];
  if ( self ) {
    
    //_address = nil;
    //_cachePolicy = NSURLRequestUseProtocolCachePolicy;
    //_timeoutInterval = 10.0;
    //_method = @"GET";
    //_headers = [[NSMutableDictionary alloc] init];
    //_body = nil;
    //_formFields = nil;
    
    _request = request;
    
    //_response = nil;
    //_responseData = nil;
    //_responseFilePath = nil;
    //_responseFileHandle = nil;
    
    _shouldUpdateNetworkActivityIndicator = YES;
    
    _runLoopMode = NSRunLoopCommonModes;
    
    //_connection = nil;
    
    //_bytesWritten = 0;
    //_totalBytesWritten = 0;
    //_totalBytesExpectedToWrite = 0;
    
    //_bytesRead = 0;
    //_totalBytesRead = 0;
    //_totalBytesExpectedToRead = 0;
    
    [self transferStatusToReady];
  }
  return self;
}



#pragma mark - Lifecycle

- (void)startAsynchronous
{
  [[[self class] operationQueue] addOperation:self];
}

- (NSData *)startSynchronous
{
  
  if ( [self isCancelled] ) {
    [self transferStatusToFinished];
    return nil;
  }
  
  if ( [self isExecuting] ) {
    // Should not be here.
    return nil;
  }
  
  if ( [self isFinished] ) {
    return _responseData;
  }
  
  if ( [self isReady] ) {
    
    [self startUsingNetwork];
    [self transferStatusFromReadyToExecuting];
    
    NSURLRequest *request = (_request != nil) ? _request : [self buildRequest];
    
    __autoreleasing NSURLResponse *response = nil;
    __autoreleasing NSError *error = nil;
    
    _responseData = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    _response = response;
    _error = error;
    
    [self transferStatusFromExecutingToFinished];
    [self stopUsingNetwork];
    
    return _responseData;
  }
  
  return nil;
}

- (void)clearDelegatesAndCancel
{
  _didStartBlock = nil;
  _didUpdateBlock = nil;
  _didFailBlock = nil;
  _didFinishBlock = nil;
  
  [_observers removeAllObjects];
  
  [self cancel];
}



#pragma mark - Request header

- (void)addValue:(NSString *)value forRequestHeader:(NSString *)header
{
  if ( [header length] > 0 ) {
    
    if ( value ) {
      [_headers setObject:value forKey:header];
    } else {
      [_headers removeObjectForKey:header];
    }
    
  }
}

- (void)clearRequestHeaders
{
  [_headers removeAllObjects];
}

- (void)setRequestHeaders:(NSDictionary *)headers
{
  [_headers removeAllObjects];
  
  for ( NSString *header in [headers keyEnumerator] ) {
    NSString *value = [headers objectForKey:header];
    [_headers setObject:value forKey:header];
  }
}



#pragma mark - Request body

- (void)addValue:(id)value filename:(NSString *)filename forFormField:(NSString *)field
{
  if ( [field length] > 0 ) {
    
    if ( _formFields == nil ) {
      _formFields = [[NSMutableDictionary alloc] init];
    }
    
    if ( value ) {
      
      if ( [filename length] > 0 ) {
        
        NSDictionary *dict = @{ @"filename": filename, @"data": value };
        [_formFields setObject:dict forKey:field];
        
      } else {
        [_formFields setObject:value forKey:field];
      }
      
    } else {
      [_formFields removeObjectForKey:field];
    }
    
  }
}

- (void)clearFormFields
{
  [_formFields removeAllObjects];
  _formFields = nil;
}

- (void)setRequestBody:(NSData *)body
{
  _body = body;
}



#pragma mark - Private

- (void)startUsingNetwork
{
  if ( _shouldUpdateNetworkActivityIndicator ) {
    [[TKNAIManager sharedObject] addNetworkUser:self];
  }
}

- (void)stopUsingNetwork
{
  if ( _shouldUpdateNetworkActivityIndicator ) {
    [[TKNAIManager sharedObject] removeNetworkUser:self];
  }
}


- (NSURLRequest *)buildRequest
{
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_address]
                                                              cachePolicy:_cachePolicy
                                                          timeoutInterval:_timeoutInterval];
  
  // Request body
  NSData *data = [self buildRequestBody];
  if ( data ) {
    _body = data;
  }
  if ( [_body length] > 0 ) {
    [request setHTTPBody:_body];
    [_headers setObject:[NSString stringWithFormat:@"%u", [_body length]]
                 forKey:@"Content-Length"];
    _method = @"POST";
  }
  
  // Request header
  if ( ![_headers hasKeyEqualTo:@"Accept-Encoding"] ) {
    [_headers setObject:@"gzip" forKey:@"Accept-Encoding"];
  }
  if ( ![_headers hasKeyEqualTo:@"User-Agent"] ) {
    [_headers setObject:@"tapkit/0.1" forKey:@"User-Agent"];
  }
  for ( NSString *header in _headers ) {
    NSString *value = [_headers objectForKey:header];
    [request addValue:value forHTTPHeaderField:header];
  }
  
  // Request method
  [request setHTTPMethod:_method];
  
  return request;
}

- (NSData *)buildRequestBody
{
  if ( [_formFields count] < 1 ) {
    return nil;
  }
  
  BOOL containsFile = NO;
  
  for ( NSString *name in _formFields ) {
    id value = [_formFields objectForKey:name];
    if ( [value isKindOfClass:[NSDictionary class]] ) {
      containsFile = YES;
      break;
    }
  }
  
  NSMutableData *body = [[NSMutableData alloc] init];
  
  if ( containsFile ) {
    
    
    NSString *boundary = [NSString UUIDString];
    
    [self addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
  forRequestHeader:@"Content-Type"];
    
    NSData *prefixData = [[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *suffixData = [[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    for ( NSString *name in _formFields ) {
      
      [body appendData:prefixData];
      
      id value = [_formFields objectForKey:name];
      
      if ( [value isKindOfClass:[NSDictionary class]] ) {
        
        NSString *filename = value[ @"filename" ];
        NSData *data = value[ @"data" ];
        
        NSMutableString *field = [[NSMutableString alloc] init];
        [field appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
        [field appendFormat:@"Content-Type: %@\r\n\r\n", [filename MIMEType]];
        
        [body appendData:[field dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
      } else {
        NSMutableString *field = [[NSMutableString alloc] init];
        [field appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", name];
        [field appendFormat:@"%@\r\n", value];
        
        [body appendData:[field dataUsingEncoding:NSUTF8StringEncoding]];
      }
      
    }
    
    [body appendData:suffixData];
    
  } else {
    
    NSData *queryData = [[_formFields queryString] dataUsingEncoding:NSUTF8StringEncoding];
    [body appendData:queryData];
    
  }
  
  
  TKPRINT(@"form-data: %d", [body length]);
  return body;
}


+ (NSOperationQueue *)operationQueue
{
  static NSOperationQueue *OperationQueue = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    OperationQueue = [[NSOperationQueue alloc] init];
    [OperationQueue setMaxConcurrentOperationCount:4];
  });
  return OperationQueue;
}

+ (NSThread *)operationThread
{
  static NSThread *OperationThread = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    OperationThread = [[NSThread alloc] initWithTarget:self
                                              selector:@selector(threadBody:)
                                                object:nil];
    [OperationThread start];
  });
  return OperationThread;
}

+ (void)threadBody:(id)object
{
  while ( YES ) {
    @autoreleasepool {
      [[NSRunLoop currentRunLoop] run];
    }
  }
}



#pragma mark - NSOperation

- (void)start
{
  if ( [self isCancelled] ) {
    [self transferStatusToFinished];
    return;
  }
  
  if ( [self isExecuting] ) {
    return;
  }
  
  if ( [self isFinished] ) {
    return;
  }
  
  if ( [self isReady] ) {
    [self performSelector:@selector(main)
                 onThread:[[self class] operationThread]
               withObject:nil
            waitUntilDone:NO
                    modes:@[ _runLoopMode ]];
  }
}

- (void)cancel
{
  if ( [self isCancelled] ) {
    return;
  }
  
  if ( [self isFinished] ) {
    return;
  }
  
  if ( [self isReady] ) {
  }
  
  if ( [self isExecuting] ) {
    
    [_connection cancel];
    _connection = nil;
    
    _response = nil;
    _responseData = nil;
    //_responseFilePath = nil;
    [_responseFileHandle closeFile];
    _responseFileHandle = nil;
    [[NSFileManager defaultManager] removeItemAtPath:_responseFilePath error:NULL];
    
    [self notifyObserversOperationDidFail];
    [self transferStatusFromExecutingToFinished];
    [self stopUsingNetwork];
  }
  
  [super cancel];
}


- (void)main
{
  @autoreleasepool {
    
    if ( ![self isCancelled] ) {
      
      [self startUsingNetwork];
      [self notifyObserversOperationDidStart];
      [self transferStatusFromReadyToExecuting];
      
      
      NSURLRequest *request = (_request) ? _request : [self buildRequest];
      
      _connection = [[NSURLConnection alloc] initWithRequest:request
                                                    delegate:self
                                            startImmediately:NO];
      [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:_runLoopMode];
      [_connection start];
      
    }
    
  }
}



#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  _response = response;
  
  if ( _responseFilePath ) {
    [[NSFileManager defaultManager] createFileAtPath:_responseFilePath contents:[NSData data] attributes:nil];
    _responseFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:_responseFilePath];
  } else {
    _responseData = [[NSMutableData alloc] init];
  }
  
  NSDictionary *headers = [(NSHTTPURLResponse *)_response allHeaderFields];
  _bytesRead = 0;
  _totalBytesRead = 0;
  _totalBytesExpectedToRead = [headers[ @"Content-Length" ] intValue];
  //TKPRINT(@"READ: %d %d/%d", _bytesRead, _totalBytesRead, _totalBytesExpectedToRead);
  
  [self notifyObserversOperationDidUpdate];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  if ( _responseFileHandle ) {
    [_responseFileHandle seekToEndOfFile];
    [_responseFileHandle writeData:data];
    [_responseFileHandle synchronizeFile];
  } else {
    [(NSMutableData *)_responseData appendData:data];
  }
  
  _bytesRead = [data length];
  _totalBytesRead += _bytesRead;
  //_totalBytesExpectedToRead = 0;
  //TKPRINT(@"READ: %d %d/%d", _bytesRead, _totalBytesRead, _totalBytesExpectedToRead);
  
  [self notifyObserversOperationDidUpdate];
}

- (void)connection:(NSURLConnection *)connection
    didSendBodyData:(NSInteger)bytesWritten
    totalBytesWritten:(NSInteger)totalBytesWritten
    totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
  _bytesWritten = bytesWritten;
  _totalBytesWritten = totalBytesWritten;
  _totalBytesExpectedToWrite = totalBytesExpectedToWrite;
  //TKPRINT(@"WRITE: %d %d/%d", _bytesWritten, _totalBytesWritten, _totalBytesExpectedToWrite);
  
  [self notifyObserversOperationDidUpdate];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  [_responseFileHandle closeFile];
  _responseFileHandle = nil;
  
  _connection = nil;
  
  [self notifyObserversOperationDidFinish];
  [self transferStatusFromExecutingToFinished];
  [self stopUsingNetwork];
}

//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response { return nil; }
//- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request { return nil; }
//
//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse { return nil; }



#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  TKPRINTMETHOD();
  
  _response = nil;
  _responseData = nil;
  //_responseFilePath = nil;
  [_responseFileHandle closeFile];
  _responseFileHandle = nil;
  [[NSFileManager defaultManager] removeItemAtPath:_responseFilePath error:NULL];
  
  _connection = nil;
  
  [self notifyObserversOperationDidFail];
  [self transferStatusFromExecutingToFinished];
  [self stopUsingNetwork];
}

//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {}
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace { return NO; }
//- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {}
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {}
//- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection { return NO; }

@end
