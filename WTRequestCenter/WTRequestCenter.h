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

//get请求
+(NSMutableURLRequest*)getWithURL:(NSURL*)url completionHandler:(void (^)(NSURLResponse* response,NSData *data))handler;

//post 请求
+(NSURLRequest*)postWithURL:(NSURL*)url params:(NSDictionary*)dict completionHandler:(void (^)(NSURLResponse* response,NSData *data))handler;
@end
