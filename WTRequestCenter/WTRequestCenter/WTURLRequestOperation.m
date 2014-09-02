//
//  WTURLRequestOperation.m
//  WTRequestCenter
//
//  Created by songwt on 14-8-29.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTURLRequestOperation.h"
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
        wtURLConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [wtURLConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        isReady = YES;
    }
    return self;
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
        
    }else if([self isReady])
    {
        [wtURLConnection start];
        isExecuting = YES;
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
