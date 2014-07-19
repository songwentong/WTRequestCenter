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
//            [shareQueue ru]
        }
    });
//    return [NSOperationQueue mainQueue];
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
            if (data) {
                NSLog(@"成功");
            }else
            {
                NSLog(@"失败");
            }
            handler(response,data);
        }];
    }else
    {
        handler(response.response,response.data);
    }
//    NSOperationQueue *queue = [WTRequestCenter shareQueue];

    return request;
}

+(NSURLRequest*)postWithURL:(NSURL*)url params:(NSDictionary*)dict completionHandler:(void (^)(NSURLResponse* response,NSData *data))handler
{
    NSURLCache *cache = [WTRequestCenter sharedCache];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:1.0];
    [request setHTTPMethod:@"POST"];
    
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
