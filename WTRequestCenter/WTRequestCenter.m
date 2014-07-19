//
//  WTRequestCenter.m
//  TestCache
//
//  Created by song on 14-7-19.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTRequestCenter.h"

@implementation WTRequestCenter



//清除所有缓存
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


static NSOperationQueue *shareQueue = nil;
+(NSOperationQueue*)shareQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareQueue) {
            shareQueue = [[NSOperationQueue alloc] init];
            [shareQueue setSuspended:NO];
            [shareQueue setMaxConcurrentOperationCount:10];
            shareQueue.name = @"WTRequestCentershareQueue";
            
        }
    });
    return shareQueue;
}

+(void)stopAllRequest
{
    [[WTRequestCenter shareQueue] cancelAllOperations];
}

+(NSURLCache*)sharedCache
{
    NSURLCache *cache = [NSURLCache sharedURLCache];

    return cache;
}

//清除请求的缓存
+(void)removeRequestCache:(NSURLRequest*)request
{
    NSURLCache *cache = [WTRequestCenter sharedCache];
    [cache removeCachedResponseForRequest:request];
}
#pragma mark - Block
//网络请求
void (^completionHandler) (NSURLResponse* response,NSData *data);
//图片请求
void (^imageComplectionHandler) (UIImage* image);





#pragma mark - Get
//get请求
//Available in iOS 5.0 and later.
+(NSURLRequest*)getWithURL:(NSURL*)url completionHandler:(void (^)(NSURLResponse* response,NSData *data))handler
{
    NSURLCache *cache = [WTRequestCenter sharedCache];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:1.0];
    [cache removeAllCachedResponses];
    NSCachedURLResponse *response =[cache cachedResponseForRequest:request];
    
    if (!response) {
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[WTRequestCenter shareQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
            handler(response,data);
                                       
                                   });
        }];
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        handler(response.response,response.data);
        });
    }

    return request;
}

#pragma mark - POST
// post 请求
//Available in iOS 5.0 and later.
+(NSURLRequest*)postWithURL:(NSURL*)url params:(NSDictionary*)dict completionHandler:(void (^)(NSURLResponse* response,NSData *data))handler
{
    NSURLCache *cache = [WTRequestCenter sharedCache];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:1.0];
    [request setHTTPMethod:@"POST"];
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    for (NSString *key in [dict allKeys]) {
        NSString *value = [dict valueForKey:key];
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
        [paramString appendString:str];
        [paramString appendString:@"&"];
    }
    
    paramString = [[paramString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    
    NSData *postData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    NSCachedURLResponse *response =[cache cachedResponseForRequest:request];

    if (!response) {
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[WTRequestCenter shareQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   
                   dispatch_async(dispatch_get_main_queue(), ^{
               handler(response,data);
                   });
 
        }];
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        handler(response.response,response.data);
        });
    }

    return request;
}

#pragma mark - Image
+(void)getImageWithURL:(NSURL*)url imageComplectionHandler:(void(^) (UIImage* image))handler
{
    [WTRequestCenter getWithURL:url completionHandler:^(NSURLResponse *response, NSData *data) {
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(image);
        });

    }];
}
@end
