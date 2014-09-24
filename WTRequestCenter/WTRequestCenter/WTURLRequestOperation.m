//
//  WTURLRequestOperation.m
//  WTRequestCenter
//
//  Created by songwt on 14-8-29.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTURLRequestOperation.h"
#import "WTRequestCenter.h"



static dispatch_queue_t http_request_operation_processing_queue() {
    static dispatch_queue_t af_http_request_operation_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_http_request_operation_processing_queue = dispatch_queue_create("WTRequestCenter.processing", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return af_http_request_operation_processing_queue;
}

static dispatch_group_t http_request_operation_completion_group() {
    static dispatch_group_t af_http_request_operation_completion_group;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_http_request_operation_completion_group = dispatch_group_create();
    });
    
    return af_http_request_operation_completion_group;
}


@interface WTURLRequestOperation()

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
        isReady = YES;
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
        
        NSLog(@"%s",__func__);
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
    return isReady;
}

-(BOOL)isExecuting
{
    return isExecuting;
}

-(BOOL)isFinished
{
    return isFinished;
}

-(BOOL)isCancelled
{
    return isCancelled;
}

-(void)start
{
    [self.lock lock];
    if (!isCancelled) {
        if(isReady)
        {
            [self performSelector:@selector(operationDidStart) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:@[NSRunLoopCommonModes]];
            
            
        }
    }
    [self.lock unlock];
    
    
    
}

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
        [[NSThread currentThread] setName:@"WTRequestThread"];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}


- (void)operationDidStart
{
    [self.lock lock];
    isExecuting = YES;
    
    wtURLConnection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
    
    [wtURLConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [wtURLConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [wtURLConnection start];
    [self.lock unlock];
}
- (void)cancel
{
    if (![self isFinished] && ![self isCancelled]) {
        [super cancel];
        if (isExecuting) {
            [wtURLConnection cancel];
            
        }
    }
    
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
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.lock lock];
    [self willChangeValueForKey:@"isFinished"];
    isFinished = YES;
    [self didChangeValueForKey:@"isFinished"];
//    [self completionBlock];
    [self.lock unlock];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.error = error;
    isFinished = YES;
}

@end
