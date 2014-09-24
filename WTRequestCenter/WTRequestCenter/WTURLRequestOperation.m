//
//  WTURLRequestOperation.m
//  WTRequestCenter
//
//  Created by songwt on 14-8-29.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTURLRequestOperation.h"
#import "WTRequestCenter.h"
@interface WTURLRequestOperation()
@property (nonatomic,retain,readwrite)NSURLRequest *request;
@property (nonatomic,retain,readwrite)NSURLResponse *response;
@end
@implementation WTURLRequestOperation

- (instancetype)initWithRequest:(NSURLRequest*)request
{
    self = [super init];
    if (self) {
        self.request = request;
        
        isReady = YES;
    }
    return self;
}

-(void)setCompletionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
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
    if (!isCancelled) {
        if(isReady)
        {
            
            isExecuting = YES;
            
            wtURLConnection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
            
            [wtURLConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            [wtURLConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [wtURLConnection start];
        }
    }
    
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
    isFinished = YES;
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.error = error;
    isFinished = YES;
}

@end
