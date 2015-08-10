//
//  WTRequestCenter.m
//  TestCache
//
//  Created by song on 14-7-19.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import "WTRequestCenter.h"
#import "WTURLRequestOperation.h"
#import "WTURLRequestSerialization.h"
#import "WTNetworkReachabilityManager.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif
//请求开始的消息
NSString * const WTNetworkingOperationDidStartNotification = @"WT Networking Operation Did Start Notification";
//请求结束的消息
NSString * const WTNetworkingOperationDidFinishNotification = @"WT Networking Operation Did Finish Notification";


BOOL const WTRequestCenterDebugMode = NO;
@interface WTRequestCenter()
{

}
@end
@implementation WTRequestCenter

+(WTRequestCenter*)requestCenter
{
    return [[WTRequestCenter alloc] init];
}

#pragma mark - Reachability
static WTNetworkReachabilityManager *sharedReachbility = nil;
//static NetworkStatus currentNetworkStatus = NotReachable;
+(WTNetworkReachabilityManager*)sharedReachability
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedReachbility = [WTNetworkReachabilityManager sharedManager];
        
//        currentNetworkStatus = [sharedReachbility currentReachabilityStatus];
        
        
        
        [[NSNotificationCenter defaultCenter] addObserverForName:WTNetworkingReachabilityDidChangeNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
        {
//            currentNetworkStatus = [sharedReachbility currentReachabilityStatus];
        }];
         
        [sharedReachbility startMonitoring];
        
    });
    
    return sharedReachbility;
    
}
#pragma mark - 请求队列和缓存
//请求队列
static NSOperationQueue *sharedQueue = nil;
+(NSOperationQueue*)sharedQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueue = [[NSOperationQueue alloc] init];
        [sharedQueue setSuspended:NO];
        sharedQueue.name = @"WTRequestCentersharedQueue";
    });
    return sharedQueue;
}


//缓存
static NSURLCache* sharedCache = nil;
+(NSURLCache*)sharedCache
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *diskPath = [NSString stringWithFormat:@"WTRequestCenter"];
        
        
        
        sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:1024*1024*10
                                                    diskCapacity:1024*1024*1024
                                                        diskPath:diskPath];
    });
    //    10M内存  1G硬盘
    return sharedCache;
}


#pragma mark - 配置设置



//清除所有缓存(clearAllCache)
+(void)clearAllCache
{
    NSURLCache *cache = [WTRequestCenter sharedCache];
    [cache removeAllCachedResponses];
    
}



//当前缓存大小
+(NSUInteger)currentDiskUsage
{
    NSURLCache *cache = [WTRequestCenter sharedCache];
    
    return [cache currentDiskUsage];
}


//当前缓存用量，直接根据大小来调节单位的显示，KB，MB，GB，TB，PB，EB
+(NSString*)currentDiskUsageString
{
    NSUInteger usage = [self currentDiskUsage];
    
    //    如果小于1M，就显示为0，因为cache数据库本身在没有数据的情况下是123KB或者218KB
    if (usage<1024*1024) {
        usage = 0;
    }
    return [NSByteCountFormatter stringFromByteCount:usage countStyle:NSByteCountFormatterCountStyleFile];
}

+(void)cancelAllRequest
{
    [[WTRequestCenter sharedQueue] cancelAllOperations];
}


//清除请求的缓存
+(void)removeCachedResponseForRequest:(NSURLRequest*)request
{
    NSURLCache *cache = [WTRequestCenter sharedCache];
    [cache removeCachedResponseForRequest:request];
}
#pragma mark - 辅助
+(id)JSONObjectWithData:(NSData*)data
{
    if (!data) {
        return nil;
    }
    //    容器解析成可变的，string解析成可变的，并且允许顶对象不是dict或者array
    NSJSONReadingOptions option = NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments;
    
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:option
                                             error:nil];
}

+(NSData*)dataFromJSONObject:(id)object
{
    if ([NSJSONSerialization isValidJSONObject:object]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
        return data;
    }
    return nil;
}


//这个方法用于类型不固定时候的一个过滤
//传入一个NSNumber，NSString或者NSNull类型的数据即可
+(NSString*)stringWithData:(NSObject*)data
{
    if ([data isEqual:[NSNull null]]) {
        return @"";
    }
    if ([data isKindOfClass:[NSString class]]) {
        return (NSString*)data;
    }
    if ([data isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber*)data;
        return [number stringValue];
    }
    return @"";
}


#pragma mark - Get

//get请求
//Available in iOS 5.0 and later.

+(NSURLRequest*)getWithURL:(NSString*)url
                parameters:(NSDictionary*)parameters
                  finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [[WTURLRequestSerialization sharedRequestSerialization] requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];
    [self doURLRequest:request finished:finished failed:failed];
    return request;
}



+(NSURLRequest*)GETUsingCache:(NSString*)url
                   parameters:(NSDictionary *)parameters
                     finished:(WTRequestFinishedBlock)finished
                       failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [[WTURLRequestSerialization sharedRequestSerialization]requestWithMethod:@"GET" URLString:url parameters:parameters error:nil];
    __block NSCachedURLResponse *cachedResponse = [[self sharedCache] cachedResponseForRequest:request];
    NSData *cacheData = cachedResponse.data;
    if (cachedResponse) {
        if (finished) {
            finished(cachedResponse.response,cachedResponse.data);
        }
    }else{
        [self doURLRequest:request finished:^(NSURLResponse *response, NSData *data) {
            if (![data isEqualToData:cacheData]) {
                if (finished) {
                    finished(response,data);
                }
            }
            cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
            [[self sharedCache] storeCachedResponse:cachedResponse forRequest:request];
            
        } failed:failed];
    }
    
    
    return request;
}


#pragma mark - POST


+(NSURLRequest*)postWithURL:(NSString*)url
                 parameters:(NSDictionary*)parameters
                   finished:(WTRequestFinishedBlock)finished
                     failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [[WTURLRequestSerialization sharedRequestSerialization] requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];
    [self doURLRequest:request finished:finished failed:failed];
    return request;
}




+(NSURLRequest*)postWithURL:(NSString*)url
                 parameters:(NSDictionary*)parameters
  constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block
                   finished:(WTRequestFinishedBlock)finished
                     failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [[WTURLRequestSerialization sharedRequestSerialization] POSTRequestWithURL:url parameters:parameters constructingBodyWithBlock:block];
    [self doURLRequest:request finished:finished failed:failed];
    
    return request;
}


+(NSURLRequest*)putWithURL:(NSString*)url
                parameters:(NSDictionary*)parameters
                  finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [[WTURLRequestSerialization sharedRequestSerialization] requestWithMethod:@"PUT" URLString:url parameters:parameters error:nil];
    [self doURLRequest:request finished:finished failed:failed];
    return request;
}

+(NSURLRequest*)deleteWithURL:(NSString*)url
                   parameters:(NSDictionary*)parameters
                     finished:(WTRequestFinishedBlock)finished
                       failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [[WTURLRequestSerialization sharedRequestSerialization] requestWithMethod:@"DELETE" URLString:url parameters:parameters error:nil];
    [self doURLRequest:request
              finished:finished
                failed:failed];
    return request;
}


+(NSURLRequest*)headWithURL:(NSString*)url
                 parameters:(NSDictionary*)parameters
                   finished:(WTRequestFinishedBlock)finished
                     failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [[WTURLRequestSerialization sharedRequestSerialization] requestWithMethod:@"HEAD" URLString:url parameters:parameters error:nil];
    [self doURLRequest:request
              finished:finished
                failed:failed];
    return request;
}


#pragma mark - Request



+(void)doURLRequest:(NSURLRequest*)request
           finished:(WTRequestFinishedBlock)finished
             failed:(WTRequestFailedBlock)failed

{
    //    有效性判断
    assert(request != nil);
    
    [self sharedReachability];
    [self sendRequestStartNotificationWithRequest:request];
    
    
    void (^complection)(NSURLResponse *response,NSData *data,NSError *error);
    
    complection = ^(NSURLResponse *response,NSData *data,NSError *connectionError)
    {

        
        [self sendRequestCompleteNotificationWithRequest:request
                                                response:response
                                                    data:data];
        
        [self logRequesEndWithRequest:request
                             response:response
                                error:connectionError];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (connectionError) {
                if (failed) {
                    failed(response,connectionError);
                }
                
            }else
            {
                if (finished) {
                    finished(response,data);
                }
                
            }
        }];
    };
    
    
    
    if ([self sharedReachability].reachable) {
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:@"似乎已断开与互联网的连接。"
                    forKey:@"NSLocalizedDescription"];
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                             code:-1009
                                         userInfo:userInfo];
        if (complection) {
            complection(nil,nil,error);
        }
    }
    
    [self logRequestStart:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[WTRequestCenter sharedQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        complection(response,data,connectionError);
    }];
    
    
    
}










#pragma mark - request Notification
//请求成功的消息
+(void)sendRequestStartNotificationWithRequest:(NSURLRequest *)request
{
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (request) {
        [userInfo setValue:request forKey:@"request"];
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WTNetworkingOperationDidStartNotification
                                                            object:nil
                                                          userInfo:userInfo];
    }];
    
    
    
}

+(void)logRequestStart:(NSURLRequest*)request
{
    if (WTRequestCenterDebugMode) {
        NSString *parameters = @"";
        parameters = [[NSString alloc] initWithData:request.HTTPBody
                                           encoding:NSUTF8StringEncoding];
        NSString *string = [NSString stringWithFormat:@"\n\nWTRequestCenter request start:\n%@\n",request];
        if (parameters) {
            string = [NSString stringWithFormat:@"%@parameters:%@\n\n",string,parameters];
        }
        NSLog(@"%@",string);
        
        
        
    }
}

+(void)logRequesEndWithRequest:(NSURLRequest*)request
                      response:(NSURLResponse*)response
                         error:(NSError*)error
{
    if (WTRequestCenterDebugMode) {
        NSString *text = @"";
        if (error) {
            text = [NSString stringWithFormat:@"\n\nWTRequestCenter request failed:\n\nrequest:%@\n",request];
        }else
        {
            text = [NSString stringWithFormat:@"\n\nWTRequestCenter request finished:%@  time:\n\n",request];
            
        }
        NSLog(@"%@",text);
    }
    
}




//请求失败的消息
+(void)sendRequestCompleteNotificationWithRequest:(NSURLRequest*)request
                                         response:(NSURLResponse*)response
                                             data:(NSData*)data
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (request) {
        [userInfo setValue:request forKey:@"request"];
    }
    if (response) {
        [userInfo setValue:response forKey:@"response"];
    }
    if (data) {
        [userInfo setValue:data forKey:@"data"];
    }
    NSDate *date = [NSDate date];
    [userInfo setValue:date forKey:@"date"];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:WTNetworkingOperationDidFinishNotification object:request userInfo:userInfo];
    }];
    
}








+ (NSString *)debugDescription
{
    return @"just a joke";
}




#pragma mark - 延时的方法
void perform(dispatch_block_t block , NSTimeInterval delay)
{
    [WTRequestCenter performBlock:block afterDelay:delay];
}

+(void)performBlock:(dispatch_block_t)block afterDelay:(NSTimeInterval)delay
{
    
    [self performBlock:block
               inQueue:dispatch_get_main_queue()
            afterDelay:delay];
}


+(void)performBlock:(dispatch_block_t)block inQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay
{
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, delay*1000*1000*1000);
    dispatch_after(t, queue, ^{
        if (block) {
            block();
        }
    });
}


#pragma mark - 实例方法 （1.0）

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //        请求生成类
        self.requestSerializer = [[WTURLRequestSerialization alloc] init];
        self.reqeustTimeInterval = 0;
        self.localRequests = [NSMutableArray array];
        self.operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 4;
        [_operationQueue setSuspended:NO];
        
        
        [[NSNotificationCenter defaultCenter] addObserverForName:WTNetworkingOperationDidFinishNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            if (_reqeustTimeInterval!=0) {
//                NSDictionary *userInfo = note.userInfo;
//                NSLog(@"%@",userInfo);
                [_localRequests addObject:note.userInfo];
            }
        }];
        
        
        
    }
    return self;
}

-(NSURLResponse*)responseInRequestTimeInterval:(NSURLRequest*)request{
    __block NSURLResponse *result = nil;
    if (_reqeustTimeInterval==0) {

    }else
    {
        [_localRequests enumerateObjectsUsingBlock:^(NSDictionary *userInfo, NSUInteger idx, BOOL *stop) {
            NSURLRequest *request2 = [userInfo valueForKey:@"request"];
            NSDate *date2 = [userInfo valueForKey:@"date"];
            NSDate *date1 = [NSDate date];
//            如果两个请求相同
            if ([request2 isEqual:request]) {
//                并且时间间隔小于对应的时间间隔
                if ([date1 timeIntervalSinceNow]-[date2 timeIntervalSinceNow]<_reqeustTimeInterval) {
                                result = [userInfo valueForKey:@"response"];
                }
            }
        }];
    }
    return result;
}

-(WTURLRequestOperation*)HTTPRequestWithRequest:(NSURLRequest*)request
                                       finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                                         failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed
{
    WTURLRequestOperation *operation = nil;
    operation = [[WTURLRequestOperation alloc] initWithRequest:request];

    [operation setCompletionBlockWithfinished:finished
                                       failed:failed];
    operation.credential = self.credential;
    
    return operation;
}


- (WTURLRequestOperation *)HTTPRequestOperationWithHTTPMethod:(NSString *)method
                                                    URLString:(NSString *)URLString
                                                   parameters:(NSDictionary*)parameters
                                                     finished:(void (^)(WTURLRequestOperation *operation, NSData *data))finished
                                                       failed:(void (^)(WTURLRequestOperation *operation, NSError *error))failed
{
    [[self class] sharedReachability];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method
                                                                   URLString:URLString
                                                                  parameters:parameters
                                                                       error:nil];
    return [self HTTPRequestWithRequest:request
                               finished:finished
                                 failed:failed];
}
-(WTURLRequestOperation*)GET:(NSString*)urlString
                  parameters:(NSDictionary*)parameters
                    finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                      failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed
{
    WTURLRequestOperation *operation = nil;
    operation = [self HTTPRequestOperationWithHTTPMethod:@"GET"
                                               URLString:urlString
                                              parameters:parameters
                                                finished:finished
                                                  failed:failed];
    [self.operationQueue addOperation:operation];
    return operation;
}

-(WTURLRequestOperation*)GETUsingCache:(NSString*)urlString
                            parameters:(NSDictionary*)parameters
                              finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                                failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed
{
    WTURLRequestOperation *operation = nil;
    operation = [self HTTPRequestOperationWithHTTPMethod:@"GET"
                                               URLString:urlString
                                              parameters:parameters
                                                finished:finished
                                                  failed:failed];
    operation.shouldCache = YES;
    [self.operationQueue addOperation:operation];
    return operation;
}

-(WTURLRequestOperation*)HEAD:(NSString*)urlString
                   parameters:(NSDictionary*)parameters
                     finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                       failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed
{
    WTURLRequestOperation *operation = nil;
    operation = [self HTTPRequestOperationWithHTTPMethod:@"HEAD"
                                               URLString:urlString
                                              parameters:parameters
                                                finished:finished
                                                  failed:failed];
    [self.operationQueue addOperation:operation];
    return operation;
}
-(WTURLRequestOperation*)POST:(NSString*)urlString
                   parameters:(NSDictionary*)parameters
                     finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                       failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed
{
    WTURLRequestOperation *operation = nil;
    operation = [self HTTPRequestOperationWithHTTPMethod:@"POST"
                                               URLString:urlString
                                              parameters:parameters
                                                finished:finished
                                                  failed:failed];
    [self.operationQueue addOperation:operation];
    return operation;
}

-(WTURLRequestOperation*)POST:(NSString*)urlString
                   parameters:(NSDictionary*)parameters
    constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block
                     finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                       failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed
{
    WTURLRequestOperation *operation = nil;
    NSMutableURLRequest *req = [self.requestSerializer POSTRequestWithURL:urlString
                                                               parameters:parameters
                                                constructingBodyWithBlock:block];
    operation = [self HTTPRequestWithRequest:req
                                    finished:finished
                                      failed:failed];
    [self.operationQueue addOperation:operation];
    return operation;
}


-(WTURLRequestOperation*)PUT:(NSString*)urlString
                  parameters:(NSDictionary*)parameters
                    finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                      failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed
{
    WTURLRequestOperation *operation = nil;
    operation = [self HTTPRequestOperationWithHTTPMethod:@"PUT"
                                               URLString:urlString
                                              parameters:parameters
                                                finished:finished
                                                  failed:failed];
    [self.operationQueue addOperation:operation];
    return operation;
}

-(WTURLRequestOperation*)DELETE:(NSString*)urlString
                     parameters:(NSDictionary*)parameters
                       finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                         failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed
{
    WTURLRequestOperation *operation = nil;
    operation = [self HTTPRequestOperationWithHTTPMethod:@"DELETE"
                                               URLString:urlString
                                              parameters:parameters
                                                finished:finished
                                                  failed:failed];
    [self.operationQueue addOperation:operation];
    return operation;
}
@end
