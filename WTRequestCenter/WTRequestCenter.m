//
//  WTRequestCenter.m
//  TestCache
//
//  Created by song on 14-7-19.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTRequestCenter.h"

@implementation WTRequestCenter
+(void)clearAllCache
{
    NSURLCache *cache = [WTRequestCenter sharedCache];
    [cache removeAllCachedResponses];
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

+(void)removeRequest:(NSURLRequest*)request
{
    NSURLCache *cache = [WTRequestCenter sharedCache];
    [cache removeCachedResponseForRequest:request];
}

void (^completionHander) (NSURLResponse* response,NSData *data);

+(NSURLRequest*)getWithURL:(NSURL*)url completionHandler:(void (^)(NSURLResponse* response,NSData *data))handler
{
    NSURLCache *cache = [WTRequestCenter sharedCache];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:1.0];
    [cache removeAllCachedResponses];
    NSCachedURLResponse *response =[cache cachedResponseForRequest:request];

    if (!response) {
        [NSURLConnection sendAsynchronousRequest:request queue:[WTRequestCenter shareQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            handler(response,data);
        }];
    }else
    {
        handler(response.response,response.data);
    }

    return request;
}


// post 请求
+(NSURLRequest*)postWithURL:(NSURL*)url params:(NSDictionary*)dict completionHandler:(void (^)(NSURLResponse* response,NSData *data))handler
{
    NSURLCache *cache = [WTRequestCenter sharedCache];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:1.0];
    [request setHTTPMethod:@"POST"];
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    for (NSString *key in [dict allKeys]) {
        NSString *value = [dict valueForKey:key];
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
        [paramString appendString:str];
        [paramString appendString:@"&"];
    }
    NSData *postData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    NSCachedURLResponse *response =[cache cachedResponseForRequest:request];
    
    if (!response) {
        [NSURLConnection sendAsynchronousRequest:request queue:[WTRequestCenter shareQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

            handler(response,data);
        }];
    }else
    {
        handler(response.response,response.data);
    }
    return request;
}
@end
