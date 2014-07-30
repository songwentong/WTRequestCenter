//
//  WTRequestCenter.h
//  TestCache
//
//  Created by song on 14-7-19.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import <Foundation/Foundation.h>
#import "UIImageView+WTImageCache.h"
@interface WTRequestCenter : NSObject

//请求队列
+(NSOperationQueue*)shareQueue;
//缓存
+(NSURLCache*)sharedCache;

//设置失效日期,单位是秒
+(void)setExpireTimeInterval:(NSTimeInterval)expireTime;

//失效日期
+(NSTimeInterval)expireTimeInterval;

//清除所有缓存
+(void)clearAllCache;

//停止所有的请求  建议在NavigationController pop之前调用，防止崩溃
+(void)stopAllRequest;

//当前缓存大小，目前有问题，不建议用
+(NSUInteger)currentDiskUsage;

//清除请求的缓存
+(void)removeRequestCache:(NSURLRequest*)request;


#pragma mark - GET (Cache)
//get请求
+(NSURLRequest*)getWithURL:(NSURL*)url
                parameters:(NSDictionary*)parameters
         completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler;

#pragma mark - POST
//post 请求  (Cache)
+(NSURLRequest*)postWithURL:(NSURL*)url
                 parameters:(NSDictionary*)parameters
          completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler;


//不使用缓存的post请求  (Without Cache)
+(NSURLRequest*)postWithoutCacheURL:(NSURL*)url
                         parameters:(NSDictionary*)parameters
                  completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler;

#pragma mark - Image
//图片上传  Upload
+(void)upLoadImageWithURL:(NSURL*)url
                     data:(NSData *)data
                 fileName:(NSString*)fileName
        completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler;

//多图片上传
+(void)upLoadImageWithURL:(NSURL*)url
                    datas:(NSArray*)datas
                fileNames:(NSArray*)names
        completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler;


//下载图片  Download  (Cache)
+(void)getImageWithURL:(NSURL*)url
     completionHandler:(void(^) (UIImage* image))handler;

#pragma mark - URL

//实际应用示例
+(NSString*)urlWithIndex:(NSInteger)index;


@end
