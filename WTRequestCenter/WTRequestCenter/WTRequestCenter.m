//
//  WTRequestCenter.m
//  TestCache
//
//  Created by song on 14-7-19.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import "WTRequestCenter.h"
#import "WTURLRequestOperation.h"
@implementation WTRequestCenter



#pragma mark - 请求队列和缓存
//请求队列
static NSOperationQueue *sharedQueue = nil;
+(NSOperationQueue*)sharedQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueue = [[NSOperationQueue alloc] init];
        [sharedQueue setSuspended:NO];
        [sharedQueue setMaxConcurrentOperationCount:20];
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
        sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:1024*1024*30 diskCapacity:1024*1024*300 diskPath:diskPath];
    });
//    30M内存  300M硬盘
    return sharedCache;
}


#pragma mark - 配置设置

-(BOOL)isRequesting
{
    BOOL requesting = NO;
    NSOperationQueue *sharedQueue = [WTRequestCenter sharedQueue];
    
    if ([sharedQueue operationCount]!=0) {
        requesting = YES;
    }
    return requesting;
}
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
+(NSUserDefaults*)sharedUserDefaults
{
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSUserDefaults *myUserDefaults = nil;
    if (currentDevice.systemVersion.floatValue>=7.0) {
//        使用新方法
       myUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"WTRequestCenter"];
    }else
    {
//    使用旧方法
//        __IPHONE_OS_VERSION_MIN_REQUIRED
        #if __IPHONE_OS_VERSION_MIN_REQUIRED <__IPHONE_7_0
        myUserDefaults = [[NSUserDefaults alloc] initWithUser:@"WTRequestCenter"];
        #endif
    }
    return myUserDefaults;
}

//设置失效日期
+(void)setExpireTimeInterval:(NSTimeInterval)expireTime
{
    NSUserDefaults *myUserDefaults = [WTRequestCenter sharedUserDefaults];
    [myUserDefaults setFloat:expireTime forKey:@"WTRequestCenterExpireTime"];
    [myUserDefaults synchronize];
}

//失效日期
+(NSTimeInterval)expireTimeInterval
{
    
    NSUserDefaults *myUserDefaults = [WTRequestCenter sharedUserDefaults];
    CGFloat time = [myUserDefaults floatForKey:@"WTRequestCenterExpireTime"];
    if (time==0) {
        time=3600*24*30;
    }
    return time;
}
#endif
+(BOOL)checkRequestIsExpired:(NSHTTPURLResponse*)request
{

    NSDictionary *allHeaderFields = request.allHeaderFields;
    
    NSString *dateString = [allHeaderFields valueForKey:@"Date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee, dd MMM yyyy HH:mm:ss VVVV"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *now = [NSDate date];
    //            NSString *string = [formatter stringFromDate:now];
    //            NSLog(@"%@",string);
    NSDate *date = [formatter dateFromString:dateString];
    //            NSLog(@"%@",date);
    
    NSTimeInterval delta = [now timeIntervalSince1970] - [date timeIntervalSince1970];
    NSTimeInterval expireTimeInterval = [WTRequestCenter expireTimeInterval];
    if (delta<expireTimeInterval) {
//        没有失效
        return NO;
    }else
    {
//        失效了
        return YES;
    }
    
}


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

+(void)cancelAllRequest
{
    [[WTRequestCenter sharedQueue] cancelAllOperations];

}


//清除请求的缓存
+(void)removeRequestCache:(NSURLRequest*)request
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
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:nil];
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
#pragma mark - 请求的生成
+(NSURLRequest*)GETRequestWithURL:(NSURL*)url
                       parameters:(NSDictionary*)parameters
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    if (parameters) {
        NSMutableString *paramString = [[NSMutableString alloc] init];
        
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
            [paramString appendString:str];
            [paramString appendString:@"&"];
        }];
        
        if ([paramString hasSuffix:@"&"]) {
            paramString =[[paramString substringToIndex:[paramString length]-1] mutableCopy];
        }
        if ([paramString length]>0) {
            NSMutableString *urlString = [[NSMutableString alloc] initWithFormat:@"%@?%@",url,paramString];
            urlString = [[[urlString copy] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
            request.URL = [NSURL URLWithString:urlString];
        }
       
        
    }
    
    return request;
}

+(NSURLRequest*)POSTRequestWithURL:(NSURL*)url
                        parameters:(NSDictionary*)parameters
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    if (parameters) {
        NSMutableString *paramString = [[NSMutableString alloc] init];
        
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
            [paramString appendString:str];
            [paramString appendString:@"&"];
        }];
        
        NSData *postData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:postData];
    }
    return request;
}




#pragma mark - Get




//get请求
//Available in iOS 5.0 and later.
+(NSURLRequest*)getWithURL:(NSURL*)url
                parameters:(NSDictionary*)parameters
         completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
    return [self getWithURL:url parameters:parameters option:WTRequestCenterCachePolicyNormal completionHandler:handler];
}


//用缓存，没有缓存就网络请求
+(NSURLRequest*)getCacheWithURL:(NSURL*)url
                parameters:(NSDictionary*)parameters
         completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
    return [self getWithURL:url parameters:parameters option:WTRequestCenterCachePolicyCacheElseWeb completionHandler:handler];
}

+(NSURLRequest*)getWithURL:(NSURL*)url
                parameters:(NSDictionary *)parameters
                    option:(WTRequestCenterCachePolicy)option
         completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
    NSURLRequest *request = [self GETRequestWithURL:url parameters:parameters];
   
    NSCachedURLResponse *response = [[self sharedCache] cachedResponseForRequest:request];
    switch (option) {
        case WTRequestCenterCachePolicyNormal:
        {
            [self doWTRequest:request completionHandler:handler];
//            [self testDoWTRequest:request completionHandler:handler];
        }
            break;
        case WTRequestCenterCachePolicyCacheElseWeb:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(response.response,response.data,nil);
                    }
                });
            }else
            {
//                [self testDoWTRequest:request completionHandler:handler];
                [self doWTRequest:request completionHandler:handler];
            }
        }
            break;
        case WTRequestCenterCachePolicyOnlyCache:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(response.response,response.data,nil);
                    }
                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(nil,nil,nil);
                    }
                });
            }
        }
            break;
        case WTRequestCenterCachePolicyCacheAndRefresh:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(response.response,response.data,nil);
                    }
                });
                [self doWTRequest:request completionHandler:nil];
            }else
            {
                [self doWTRequest:request completionHandler:handler];
            }
            
//            [self testDoWTRequest:request completionHandler:handler];
            
        }
            break;
        case WTRequestCenterCachePolicyCacheAndWeb:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(response.response,response.data,nil);
                    }
                });
                [self doWTRequest:request completionHandler:handler];
            }else
            {
                [self doWTRequest:request completionHandler:handler];
            }
        }
            break;
        default:
            break;
    }
    return request;
}
#pragma mark - POST
+(NSURLRequest*)postWithURL:(NSURL*)url
                 parameters:(NSDictionary*)parameters
          completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
    
    NSURLRequest *request = [self postWithURL:url parameters:parameters option:WTRequestCenterCachePolicyNormal completionHandler:handler];
    return request;
}


+(NSURLRequest*)postWithURL:(NSURL*)url
                parameters:(NSDictionary *)parameters
                    option:(WTRequestCenterCachePolicy)option
         completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
    
    NSURLRequest *request = [self POSTRequestWithURL:url parameters:parameters];

    NSCachedURLResponse *response = [[self sharedCache] cachedResponseForRequest:request];
    switch (option) {
        case WTRequestCenterCachePolicyNormal:
        {
            [self doWTRequest:request completionHandler:handler];
        }
            break;
        case WTRequestCenterCachePolicyCacheElseWeb:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(response.response,response.data,nil);
                    }
                });
            }else
            {
                [self doWTRequest:request completionHandler:handler];
            }
        }
            break;
        case WTRequestCenterCachePolicyOnlyCache:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(response.response,response.data,nil);
                    }
                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(nil,nil,nil);
                    }
                });
            }
        }
            break;
        case WTRequestCenterCachePolicyCacheAndRefresh:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(response.response,response.data,nil);
                    }
                });
                [self doWTRequest:request completionHandler:nil];
            }else
            {

                [self doWTRequest:request completionHandler:handler];
            }
            
            
//            [self testDoWTRequest:request completionHandler:handler];
        }
            break;
            case WTRequestCenterCachePolicyCacheAndWeb:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(response.response,response.data,nil);
                    }
                });
                [self doWTRequest:request completionHandler:handler];
            }else
            {
                
                [self doWTRequest:request completionHandler:handler];
            }
        }
            break;
            
        default:
            break;
    }
    return request;

}



#pragma mark - Request


+(void)doWTRequest:(NSURLRequest*)request
 completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
    [NSURLConnection sendAsynchronousRequest:request queue:[WTRequestCenter sharedQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (!connectionError) {
            NSCachedURLResponse *tempURLResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
            [[self sharedCache] storeCachedResponse:tempURLResponse forRequest:request];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(response,data,connectionError);
            }
        });
        
    }];
}

+(void)doWTRequest:(NSURLRequest*)request
            option:(WTRequestCenterCachePolicy)option
 completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
    NSCachedURLResponse *response = [[self sharedCache] cachedResponseForRequest:request];
    
    switch (option) {
        case WTRequestCenterCachePolicyNormal:
        {
            [self doWTRequest:request completionHandler:handler];
        }
            break;
            
        case WTRequestCenterCachePolicyCacheElseWeb:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(response.response,response.data,nil);
                    }
                });
            }else
            {
                [self doWTRequest:request completionHandler:handler];
            }
        }
            break;
            
        case WTRequestCenterCachePolicyOnlyCache:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    if (response) {
                        handler(nil,nil,nil);
                    }else
                    {
                        handler(response.response,response.data,nil);
                    }
                    
                }
            });
        }
            break;
            
        case WTRequestCenterCachePolicyCacheAndRefresh:
        {
            
            //          如果有本地的，也去刷新，刷新后不回调，如果没有，则用网络的
            
            if (response) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(response.response,response.data,nil);
                    }
                });
                [self doWTRequest:request completionHandler:nil];
            }else
            {
                [self doWTRequest:request completionHandler:handler];
            }
            
            
        }
            break;
        
            
        default:
            break;
    }

}



#pragma mark - Image
+(NSURLRequest *)uploadRequestWithURL: (NSURL *)url

                               data: (NSData *)data
                           fileName: (NSString*)fileName
{
    
    // from http://www.cocoadev.com/index.pl?HTTPFileUpload
    
    //NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init] ;
    urlRequest.URL = url;
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *myboundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",myboundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    //[urlRequest addValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postData = [NSMutableData data]; //[NSMutableData dataWithCapacity:[data length] + 512];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", fileName]dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[NSData dataWithData:data]];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlRequest setHTTPBody:postData];
    return urlRequest;
}


//图片上传
+(void)upLoadImageWithURL:(NSURL*)url
                     data:(NSData *)data
                 fileName:(NSString*)fileName
completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
    NSURLRequest *request = [WTRequestCenter uploadRequestWithURL:url data:data fileName:fileName];
    [NSURLConnection sendAsynchronousRequest:request queue:[WTRequestCenter sharedQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(response,data,connectionError);
            }
        });
    }];
}



//多图片上传
+(void)upLoadImageWithURL:(NSURL*)url
                    datas:(NSArray*)datas
                fileNames:(NSArray*)names
        completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
    for (int i=0; i<[datas count]; i++) {
        NSData *data = datas[i];
        NSString *name = names[i];
        [WTRequestCenter upLoadImageWithURL:url data:data fileName:name completionHandler:handler];
    }
}
 




#pragma mark - URL

+(BOOL)setBaseURL:(NSString*)url
{
    NSUserDefaults *a = [self sharedUserDefaults];
    [a setValue:url forKey:@"baseURL"];
    return [a synchronize];
}

+(NSString *)baseURL
{
    NSUserDefaults *a = [self sharedUserDefaults];
    NSString *url = [a valueForKey:@"baseURL"];
    if (!url) {
        return @"http://www.xxx.com";
    }
    return url;

}
//实际应用示例
+(NSString*)urlWithIndex:(NSInteger)index
{
    NSMutableArray *urls = [[NSMutableArray alloc] init];
//    0-9
    [urls addObject:@"article/detail"];
    [urls addObject:@"interface1"];
    [urls addObject:@"interface2"];
    [urls addObject:@"interface3"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    
//  10-19
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    [urls addObject:@"interface0"];
    
    
    
    NSString *url = urls[index];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",[WTRequestCenter baseURL],url];
    return urlString;
}


+ (NSString *)debugDescription
{
    return @"just a joke";
}


#pragma mark - Testing Method


+(WTURLRequestOperation*)testDoWTRequest:(NSURLRequest*)request
     completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    WTURLRequestOperation *operation = nil;
    operation = [[WTURLRequestOperation alloc] initWithRequest:request];
    [operation setCompletionHandler:handler];
    [[self sharedQueue] addOperation:operation];
    return operation;
    #pragma clang diagnostic pop

}
+(WTURLRequestOperation*)testGetWithURL:(NSURL*)url
                parameters:(NSDictionary *)parameters
                    option:(WTRequestCenterCachePolicy)option
         completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
    NSURLRequest *request = [self GETRequestWithURL:url parameters:parameters];
    WTURLRequestOperation *operation = nil;
    NSCachedURLResponse *response = [[self sharedCache] cachedResponseForRequest:request];
    switch (option) {
        case WTRequestCenterCachePolicyNormal:
        {
            [self testDoWTRequest:request completionHandler:handler];
        }
            break;
        case WTRequestCenterCachePolicyCacheElseWeb:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(response.response,response.data,nil);
                    }
                });
            }else
            {
                [self testDoWTRequest:request completionHandler:handler];
            }
        }
            break;
        case WTRequestCenterCachePolicyOnlyCache:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(response.response,response.data,nil);
                    }
                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(nil,nil,nil);
                    }
                });
            }
        }
            break;
        case WTRequestCenterCachePolicyCacheAndRefresh:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(response.response,response.data,nil);
                    }
                });
                [self testDoWTRequest:request completionHandler:nil];
            }else
            {

                [self testDoWTRequest:request completionHandler:handler];
            }
            
            
        }
            break;
        case WTRequestCenterCachePolicyCacheAndWeb:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(response.response,response.data,nil);
                    }
                });
                [self testDoWTRequest:request completionHandler:handler];
            }else
            {
                
                [self testDoWTRequest:request completionHandler:handler];
            }
        }
            break;
        default:
            break;
    }
    return operation;
}
@end
