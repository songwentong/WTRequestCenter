//
//  WTURLConnectionOperation.m
//  WTRequestCenter
//
//  Created by song on 14-8-1.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTURLConnectionOperation.h"
typedef NS_ENUM(NSInteger, WTOperationState) {
    WTOperationPausedState      = -1,
    WTOperationReadyState       = 1,
    WTOperationExecutingState   = 2,
    WTOperationFinishedState    = 3,
};

@interface WTURLConnectionOperation ()
@property (readwrite, nonatomic, assign) WTOperationState state;
@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;
@property (readwrite, nonatomic, strong) NSURLConnection *connection;
@property (readwrite, nonatomic, strong) NSURLRequest *request;
@property (readwrite, nonatomic, strong) NSURLResponse *response;
@property (readwrite, nonatomic, strong) NSError *error;
@property (readwrite, nonatomic, strong) NSMutableData *responseData;
@property (readwrite, nonatomic, copy) NSString *responseString;
@property (readwrite, nonatomic, assign) NSStringEncoding responseStringEncoding;
@property (readwrite, nonatomic, assign) long long totalBytesRead;
@end
@implementation WTURLConnectionOperation
- (instancetype)initWithRequest:(NSURLRequest *)urlRequest
{
    NSParameterAssert(urlRequest);
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.request = urlRequest;
    
    
    self.lock = [[NSRecursiveLock alloc] init];
    self.connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
    
    return self;
}


#pragma mark - NSOperation
- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isReady {
    return self.state == WTOperationReadyState && [super isReady];
}


- (BOOL)isExecuting {
    return self.state == WTOperationExecutingState;
}

- (BOOL)isFinished {
    return self.state == WTOperationFinishedState;
}

- (void)start
{
    [self.lock lock];
    if ([self isReady]) {
        self.state = WTOperationExecutingState;
        [_connection start];
    }
    
    [self.lock unlock];
}

- (void)pause {
    if ([self isPaused] || [self isFinished] || [self isCancelled]) {
        return;
    }

    if ([self isExecuting]) {
        [_connection cancel];
    }
    self.state = WTOperationPausedState;
}

/**
 继续
 */
- (void)resume
{
    [_connection start];
}


#pragma mark - NSURLConnectionDelegate

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
    self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}
























@end
