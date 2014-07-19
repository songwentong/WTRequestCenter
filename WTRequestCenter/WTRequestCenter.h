//
//  WTRequestCenter.h
//  TestCache
//
//  Created by song on 14-7-19.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTRequestCenter : NSObject

//清除所有缓存
+(void)clearAllCache;

//停止所有的请求
+(void)stopAllRequest;

//清除请求的缓存
+(void)removeRequestCache:(NSURLRequest*)request;


#pragma mark - GET
//get请求
+(NSURLRequest*)getWithURL:(NSURL*)url
         completionHandler:(void (^)(NSURLResponse* response,NSData *data))handler;


#pragma mark - POST
//post 请求
+(NSURLRequest*)postWithURL:(NSURL*)url
                     params:(NSDictionary*)dict
          completionHandler:(void (^)(NSURLResponse* response,NSData *data))handler;

#pragma mark - Image
+(void)getImageWithURL:(NSURL*)url imageComplectionHandler:(void(^) (UIImage* image))handler;
@end
