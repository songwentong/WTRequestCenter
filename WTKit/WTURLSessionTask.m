//
//  WTURLSessionTask.m
//  WTKit
//
//  Created by SongWentong on 10/03/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

#import "WTURLSessionTask.h"
#import "WTNetWorkManager.h"
#import "NSOperationQueue+Nice.h"
@interface WTURLSessionManager() <NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>
@property NSMutableDictionary<NSString*,WTURLSessionTask *> *dictToSaveRequests;

@property (nonatomic,strong) NSOperationQueue *delegateQueue;
@end
@implementation WTURLSessionManager
static WTURLSessionManager* sharedManager = nil;
+(instancetype)sharedSessionManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [WTURLSessionManager new];
    });
    return sharedManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dictToSaveRequests = [NSMutableDictionary dictionary];
        self.delegateQueue = [NSOperationQueue new];
        [_delegateQueue setMaxConcurrentOperationCount:10];
        [_delegateQueue setSuspended:NO];
        self.queueToProcessGetAndSetMethod = dispatch_queue_create("serial_queue_get_set", DISPATCH_QUEUE_SERIAL);
        NSURLSessionConfiguration *config = NSURLSessionConfiguration.defaultSessionConfiguration;
        self.mySession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:_delegateQueue];
    }
    return self;
}
//设置和获取方法
-(WTURLSessionTask*)getWTTaskForTask:(NSURLSessionTask*)task
{
    __block WTURLSessionTask *wtTask = nil;
    
    dispatch_sync(_queueToProcessGetAndSetMethod, ^{
        wtTask = [_dictToSaveRequests valueForKey:[NSString stringWithFormat:@"%ld",(unsigned long)task.taskIdentifier]];
    });
    return wtTask;
}
-(void)setWTTask:(WTURLSessionTask*)wtTask forKey:(NSURLSessionTask*)task
{
    NSString *key = [NSString stringWithFormat:@"%ld",(unsigned long)task.taskIdentifier];
    dispatch_sync(_queueToProcessGetAndSetMethod, ^{
        [_dictToSaveRequests setValue:wtTask forKey:key];
    });
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error{
    
}
#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
    didCompleteWithError:(nullable NSError *)error
{
    WTURLSessionTask *wtTask = [self getWTTaskForTask:task];
    [wtTask URLSession:session task:task didCompleteWithError:error];
    
}
#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    WTURLSessionDataTask *wtTask = (WTURLSessionDataTask*)[self getWTTaskForTask:dataTask];
    [wtTask URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    WTURLSessionDataTask *wtTask = (WTURLSessionDataTask*)[self getWTTaskForTask:dataTask];
    [wtTask URLSession:session dataTask:dataTask didReceiveData:data];
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler
{
    WTURLSessionDataTask *wtTask = (WTURLSessionDataTask*)[self getWTTaskForTask:dataTask];
    [wtTask URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
}
@end
@implementation WTURLSessionTask
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheTime = 0;
    }
    return self;
}

- (void)resume
{
    [self.task resume];
}
- (void)suspend{
    [_task suspend];
}
- (void)cancel{
    [_task cancel];
}
- (void)finish{
    [[NSOperationQueue globalQueue] addOperationWithBlock:^{
        if (self.jsonHandler) {
            NSError *error = self.error;
            NSError *jsonError = nil;
            id jsonObj = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:&jsonError];
            if (error == nil) {
                error = jsonError;
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.jsonHandler(jsonObj, error);
            }];
        }
        if (self.stringHandler) {
            NSString *string = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.stringHandler(string, self.error);
            }];
        }
    }];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (self.complection) {
            self.complection(self.data,self.response,self.error);
        }
    }];
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    NSURLSessionAuthChallengeDisposition dis = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
        credential = [NSURLCredential credentialForTrust:serverTrust];
    }
    completionHandler(dis,credential);
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    self.error = error;
    [self finish];
}

@end
@implementation WTURLSessionDataTask
- (instancetype)init
{
    self = [super init];
    if (self) {
        _shouldCache = NO;
    }
    return self;
}
#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    self.data = [NSMutableData new];
    self.response = response;
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    [self.data appendData:data];
}



- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler
{
    if (self.cacheTime != 0) {
        NSCachedURLResponse *response = [[NSCachedURLResponse alloc] initWithResponse:proposedResponse.response data:proposedResponse.data userInfo:@{@"date":[NSDate date]} storagePolicy:NSURLCacheStorageAllowed];
        completionHandler(response);
    }
    [self finish];
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error{
    self.error = error;
    [self finish];
}


@end
