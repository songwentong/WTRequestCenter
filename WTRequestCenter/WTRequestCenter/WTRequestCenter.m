//
//  WTRequestCenter.m
//  TestCache
//
//  Created by song on 14-7-19.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import "WTRequestCenter.h"
#import "WTURLRequestOperation.h"



//请求开始的消息
NSString * const WTNetworkingOperationDidStartNotification = @"WTNetworkingOperationDidStartNotification";
//请求结束的消息
NSString * const WTNetworkingOperationDidFinishNotification = @"WTNetworkingOperationDidFinishNotification";

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
        sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:1024*1024*10 diskCapacity:1024*1024*1024 diskPath:diskPath];
    });
//    10M内存  1G硬盘
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


#endif


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
//    NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
//    formatter.includesActualByteCount = YES;
//    formatter.countStyle = NSByteCountFormatterCountStyleFile;
    return [NSByteCountFormatter stringFromByteCount:usage countStyle:NSByteCountFormatterCountStyleFile];
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

+(NSString*)stringFromParameters:(NSDictionary*)parameters
{
    if (parameters && [[parameters allKeys] count]>0) {
        NSMutableString *paramString = [[NSMutableString alloc] init];
        

        
        [[parameters allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger index, BOOL *stop) {
            if (index!=0) {
                [paramString appendFormat:@"&"];
            }
            [paramString appendFormat:@"%@=%@",key,[parameters valueForKey:key]];
            
        }];
        return [paramString copy];
    }
    else
    {
        return @"";
    }
}
#pragma mark - 请求的生成


+(NSURLRequest*)requestWithMethod:(NSString*)methodName
                              URL:(NSString*)url
                       parameters:(NSDictionary*)parameters
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = methodName;
    
    return request;
}


static const NSTimeInterval timeOutInterval = 30;
+(NSURLRequest*)GETRequestWithURL:(NSString*)url
                       parameters:(NSDictionary*)parameters
{
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeOutInterval];
    
    
    if (parameters && [[parameters allKeys] count]>0) {
        NSMutableString *paramString = [[self stringFromParameters:parameters] mutableCopy];
        NSMutableString *urlString = [[NSMutableString alloc] initWithFormat:@"%@?%@",url,paramString];
        urlString = [[[urlString copy] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
        request.URL = [NSURL URLWithString:urlString];
        
       
        
    }
    
    return request;
}

+(NSURLRequest*)POSTRequestWithURL:(NSString*)url
                        parameters:(NSDictionary*)parameters
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    if (parameters && [[parameters allKeys] count]>0) {
        NSMutableString *paramString = [[NSMutableString alloc] init];
        
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
            [paramString appendString:str];
            [paramString appendString:@"&"];
        }];
        if([paramString hasSuffix:@"&"]){
            paramString = [[paramString substringToIndex:[paramString length]-1] mutableCopy];
            
        }
        NSData *postData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:postData];
    }
    return request;
}




#pragma mark - Get




//get请求
//Available in iOS 5.0 and later.

+(NSURLRequest*)getWithURL:(NSString*)url
                parameters:(NSDictionary*)parameters
                  finished:(WTRequestFinishedBlock)finished
                   failed:(WTRequestFailedBlock)failed
{
    return [self getWithURL:url parameters:parameters option:WTRequestCenterCachePolicyNormal finished:finished failed:failed];
}


//用缓存，没有缓存就网络请求

+(NSURLRequest*)getCacheWithURL:(NSString*)url
                     parameters:(NSDictionary*)parameters
                         finished:(WTRequestFinishedBlock)finished
                        failed:(WTRequestFailedBlock)failed
{
    return [self getWithURL:url parameters:parameters option:WTRequestCenterCachePolicyCacheElseWeb finished:finished failed:failed];
}


+(NSURLRequest*)getWithURL:(NSString*)url
                parameters:(NSDictionary *)parameters
                    option:(WTRequestCenterCachePolicy)option
                    finished:(WTRequestFinishedBlock)finished
                   failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [self GETRequestWithURL:url parameters:parameters];
    
    [self doURLRequest:request option:option finished:finished failed:failed];
    return request;
}

#pragma mark - POST


+(NSURLRequest*)postWithURL:(NSString*)url
                 parameters:(NSDictionary*)parameters
                   finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [self postWithURL:url parameters:parameters option:WTRequestCenterCachePolicyNormal finished:finished failed:failed];
    return request;
}



+(NSURLRequest*)postWithURL:(NSString*)url
                 parameters:(NSDictionary *)parameters
                     option:(WTRequestCenterCachePolicy)option
                   finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed
{
    
    NSURLRequest *request = [self POSTRequestWithURL:url parameters:parameters];
    

    [self doURLRequest:request option:option finished:finished failed:failed];
    return request;
    
}
#pragma mark - Request
+(void)doURLRequest:(NSURLRequest*)request
          finished:(WTRequestFinishedBlock)finished
            failed:(WTRequestFailedBlock)failed
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = @{@"request": request};
        [[NSNotificationCenter defaultCenter] postNotificationName:WTNetworkingOperationDidStartNotification object:request userInfo:userInfo];
    });
    [NSURLConnection sendAsynchronousRequest:request queue:[WTRequestCenter sharedQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *userInfo = @{@"request": request};
            [[NSNotificationCenter defaultCenter] postNotificationName:WTNetworkingOperationDidFinishNotification object:request userInfo:userInfo];
        });
        

        
        
        if (!connectionError) {
            NSCachedURLResponse *tempURLResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
            [[self sharedCache] storeCachedResponse:tempURLResponse forRequest:request];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
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
        });
        
    }];
    }


+(void)doURLRequest:(NSURLRequest*)request
            option:(WTRequestCenterCachePolicy)option
          finished:(WTRequestFinishedBlock)finished
            failed:(WTRequestFailedBlock)failed
{
    NSCachedURLResponse *response = [[self sharedCache] cachedResponseForRequest:request];
    
    switch (option) {
        case WTRequestCenterCachePolicyNormal:
        {
//            [self doURLRequest:request finished: failed:failed];
            [self doURLRequest:request finished:finished failed:failed];
            
        }
            break;
            
        case WTRequestCenterCachePolicyCacheElseWeb:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(response.response,response.data);
                    }
                });
            }else
            {
                [self doURLRequest:request finished:finished failed:failed];
            }
        }
            break;
            
        case WTRequestCenterCachePolicyOnlyCache:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finished) {
                finished(response.response,response.data);
                    
                }
            });
        }
            break;
            
        case WTRequestCenterCachePolicyCacheAndRefresh:
        {
            
            //          如果有本地的，也去刷新，刷新后不回调，如果没有，则用网络的

            if (response) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(response.response,response.data);
                    }
                });
                [self doURLRequest:request finished:nil failed:nil];
            }else
            {
                [self doURLRequest:request finished:finished failed:failed];
            }
            
            
        }
            break;
        case WTRequestCenterCachePolicyCacheAndWeb:
        {
            if (response) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(response.response,response.data);
                    }
                });
                [self doURLRequest:request finished:finished failed:failed];
            }else
            {
                [self doURLRequest:request finished:finished failed:failed];
            }
            
            
        }
            break;
        
            
        default:
            break;
    }

}





#pragma mark - Image
+(NSURLRequest *)uploadRequestWithURL: (NSString *)url
                                 data: (NSData *)data
                             fileName: (NSString*)fileName
{
    
    // from http://www.cocoadev.com/index.pl?HTTPFileUpload
    
    //NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init] ;
    urlRequest.URL = [NSURL URLWithString:url];
    
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
+(void)upLoadImageWithURL:(NSString*)url
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
+(void)upLoadImageWithURL:(NSString*)url
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


+(WTURLRequestOperation*)testdoURLRequest:(NSURLRequest*)request
                                 progress:(WTDownLoadProgressBlock)progress
                                 finished:(WTRequestFinishedBlock)finished
                                   failed:(WTRequestFailedBlock)failed
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    WTURLRequestOperation *operation = nil;
    operation = [[WTURLRequestOperation alloc] initWithRequest:request];
    if (progress) {
        operation.downloadProgress = progress;
    }
    [operation setCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            if (failed) {
                failed(response,error);
            }
        }else
        {
            if (finished) {
                finished(response,data);
            }
        }
    }];
    [[self sharedQueue] addOperation:operation];
    return operation;
#pragma clang diagnostic pop
    
}


+(WTURLRequestOperation*)testdoURLRequest:(NSURLRequest*)request
                                   option:(WTRequestCenterCachePolicy)option
                                 progress:(WTDownLoadProgressBlock)progress
                                 finished:(WTRequestFinishedBlock)finished
                                   failed:(WTRequestFailedBlock)failed
{
    WTURLRequestOperation *operation = nil;
    operation = [[WTURLRequestOperation alloc] initWithRequest:request];
    if (progress) {
        operation.downloadProgress = progress;
    }
    NSCachedURLResponse *response = [[self sharedCache] cachedResponseForRequest:request];
    switch (option) {
        case WTRequestCenterCachePolicyNormal:
        {
            operation = [self testdoURLRequest:request progress:progress finished:finished failed:failed];
        }
            break;
        case WTRequestCenterCachePolicyCacheElseWeb:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(response.response,response.data);
                    }
                });
            }else
            {
               operation =  [self testdoURLRequest:request progress:progress finished:finished failed:failed];
            }
        }
            break;
        case WTRequestCenterCachePolicyOnlyCache:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(response.response,response.data);
                    }
                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(nil,nil);
                    }
                });
            }
        }
            break;
        case WTRequestCenterCachePolicyCacheAndRefresh:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(response.response,response.data);
                    }
                });
                
            }
            
            operation = [self testdoURLRequest:request progress:progress finished:finished failed:failed];
        }
            break;
        case WTRequestCenterCachePolicyCacheAndWeb:
        {
            
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(response.response,response.data);
                    }
                });
                operation = [self testdoURLRequest:request progress:nil finished:nil failed:nil];
            }else
            {
                operation = [self testdoURLRequest:request progress:progress finished:finished failed:failed];
            }
        }
            break;
        
        default:
            break;
    }
    
    return operation;
}



+(WTURLRequestOperation*)testGetWithURL:(NSString *)url parameters:(NSDictionary *)parameters finished:(WTRequestFinishedBlock)finished failed:(WTRequestFailedBlock)failed
{
    return [self testGetWithURL:url parameters:parameters option:WTRequestCenterCachePolicyNormal finished:finished failed:failed];
}
+(WTURLRequestOperation*)testGetWithURL:(NSString*)url
                             parameters:(NSDictionary *)parameters
                                 option:(WTRequestCenterCachePolicy)option
                               finished:(WTRequestFinishedBlock)finished
                                 failed:(WTRequestFailedBlock)failed
{
    return [self testGetWithURL:url parameters:parameters option:option progress:nil finished:finished failed:failed];
}

+(WTURLRequestOperation*)testGetWithURL:(NSString*)url
                             parameters:(NSDictionary *)parameters
                                 option:(WTRequestCenterCachePolicy)option
                               progress:(WTDownLoadProgressBlock)progress
                               finished:(WTRequestFinishedBlock)finished
                                 failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [self GETRequestWithURL:url parameters:parameters];
    WTURLRequestOperation *operation = [self testdoURLRequest:request option:option progress:progress finished:finished failed:failed];
    return operation;
}



+(WTURLRequestOperation*)testPOSTWithURL:(NSString*)url
                             parameters:(NSDictionary *)parameters
                               finished:(WTRequestFinishedBlock)finished
                                 failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [self POSTRequestWithURL:url parameters:parameters];
    WTURLRequestOperation *operation = [self testdoURLRequest:request progress:nil finished:finished failed:failed];
    return operation;
}

@end
