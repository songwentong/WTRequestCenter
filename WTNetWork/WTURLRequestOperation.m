//
//  WTURLRequestOperation.m
//  WTRequestCenter
//
//  Created by songwt on 14-8-29.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTURLRequestOperation.h"
#import "WTRequestCenter.h"




//operation 状态
typedef NS_ENUM(NSInteger, WTOperationState){
    WTOperationStatePause,
    WTOperationStateReady,
    WTOperationStateExecuting,
    WTOperationStateFinished
};


static inline NSString * WTKeyPathFromOperationState(WTOperationState state) {
    switch (state) {
        case WTOperationStatePause:
        {
            return @"isPaused";
        }
            break;
        case WTOperationStateReady:
        {
            return @"isReady";
        }
            break;
        case WTOperationStateExecuting:
        {
            return @"isExecuting";
        }
            break;
        case WTOperationStateFinished:
        {
            return @"isFinished";
        }
            break;
        default:
            return @"state";
            break;
    }
    
}


@interface WTURLRequestOperation()

//Operation状态
@property (readwrite, nonatomic, assign) WTOperationState state;

//锁
@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;

@property (nonatomic,retain,readwrite)NSURLRequest *request;
@property (nonatomic,retain,readwrite)NSURLResponse *response;
@end
@implementation WTURLRequestOperation

- (instancetype)initWithRequest:(NSURLRequest*)request
{
    self = [super init];
    if (self) {
        self.request = request;
        self.lock = [[NSRecursiveLock alloc] init];
        self.lock.name = @"WTRequestCenter.WTURLRequestOperation.lock";
        
        _state = WTOperationStateReady;
        
        
        self.runLoopModes = [NSSet setWithObject:NSRunLoopCommonModes];
    }
    return self;
}

-(void)setCompletionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    [self.lock lock];
    [self setCompletionBlock:^{
        
        if (!self.error) {
            //                如果请求无误
            NSCachedURLResponse *res = [[NSCachedURLResponse alloc] initWithResponse:self.response data:self.responseData];
            [[WTRequestCenter sharedCache] storeCachedResponse:res forRequest:self.request];
        }
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(self.response,self.responseData,self.error);
            });
        }
    }];
    [self.lock unlock];
#pragma clang diagnostic pop
}



-(BOOL)isConcurrent
{
    return YES;
}
-(BOOL)isReady
{
    return self.state == WTOperationStateReady;
}

-(BOOL)isExecuting
{
    return self.state == WTOperationStateExecuting;
}

-(BOOL)isFinished
{
    return self.state == WTOperationStateFinished;
}



-(void)start
{
    [self.lock lock];
    if (![self isCancelled]) {
        if([self isReady])
        {
            self.state = WTOperationStateExecuting;
            [self performSelector:@selector(operationDidStart) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
        }
    }
    
    [self.lock unlock];
}

- (void)setState:(WTOperationState)state {
    [self.lock lock];
    NSString *oldStateKey = WTKeyPathFromOperationState(self.state);
    NSString *newStateKey = WTKeyPathFromOperationState(state);
    [self willChangeValueForKey:oldStateKey];
    [self willChangeValueForKey:newStateKey];
    
    _state = state;
    [self didChangeValueForKey:oldStateKey];
    [self didChangeValueForKey:newStateKey];
    
    
    [self.lock unlock];
}



//网络访问线程
+ (NSThread *)networkRequestThread {
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    });
    
    return _networkRequestThread;
}

+ (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"WTRequestCenter"];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}


- (void)operationDidStart
{
    [self.lock lock];
    wtURLConnection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [self.runLoopModes enumerateObjectsUsingBlock:^(NSString *runLoopMode, BOOL *stop) {
        [wtURLConnection scheduleInRunLoop:runLoop forMode:runLoopMode];
    }];
    [wtURLConnection start];
    
    [WTRequestCenter sendRequestStartNotificationWithRequest:_request];
    
    [self.lock unlock];
}
- (void)cancel
{
    [self.lock lock];
    if (![self isFinished] && ![self isCancelled]) {
        [super cancel];
        if ([self isExecuting]) {
            [self performSelector:@selector(cancelConnection) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
            
        }
    }
    [self.lock unlock];
}

- (void)cancelConnection {
    NSDictionary *userInfo = nil;
    if ([self.request URL]) {
        userInfo = @{NSURLErrorFailingURLErrorKey: [self.request URL]};
    }
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:userInfo];
    
    if (![self isFinished]) {
        if (wtURLConnection) {
            [wtURLConnection cancel];
            [self performSelector:@selector(connection:didFailWithError:) withObject:wtURLConnection withObject:error];
            
        }else
        {
            self.error = error;
            [self finish];
        }
    }
}

- (void)finish {
    [self.lock lock];
    self.state = WTOperationStateFinished;
    
    
    [WTRequestCenter sendRequestCompleteNotificationWithRequest:_request
                                                       response:self.response
                                                           data:self.responseData];
    
    [self.lock unlock];
    
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
    if (_downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _downloadProgress([data length],[_responseData length],_response.expectedContentLength);
        });
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    wtURLConnection = nil;
    [self finish];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.error = error;
    wtURLConnection = nil;
    [self finish];
}

@end
