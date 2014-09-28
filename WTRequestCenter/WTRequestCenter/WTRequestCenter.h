//
//  WTRequestCenter.h
//  TestCache
//
//  Created by song on 14-7-19.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter
/*
    这是一个方便的缓存式网络请求的缓存库，在网络不好
 或者没有网络的情况下方便读取缓存来看。
 
    使用方法很简单，有GET和POST，GET的请求都是缓存
 式的，POST分缓存和非缓存。
    还提供上传图片功能，下载图片功能，缓存图片功能
 还有JSON解析功能，还提供来一个URL的表让你来填写
 然后直接快捷取URL。
    希望能帮到你，谢谢。
    如果有任何问题可以在github上向我提出
                                Mike
 
 */
#import <Foundation/Foundation.h>
#import "WTDataSaver.h"
#import "WTURLRequestOperation.h"
#if ( ( defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090) || \
( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 ) )
#import "WTURLSessionManager.h"
#endif
/*!
 @enum NSURLRequestCachePolicy
 
 WTRequestCenterCachePolicyNormal
 //正常网络访问，无缓存
 
 WTRequestCenterCachePolicyCacheElseWeb
 //如果本地有就用本地，否则用网络的
 
 WTRequestCenterCachePolicyOnlyCache
 //仅使用缓存缓存，不请求
 
 WTRequestCenterCachePolicyCacheAndRefresh
 //本地和网络的，本地没有也会刷新,本地有也会刷新(刷新后不回调)
 
 
 WTRequestCenterCachePolicyCacheAndWeb
 本地有，会用，也会刷新，也会回调，本地没有会刷新
 注意：这种情况非常少见，只有调用网页的时候可能会用得到
 
 */

typedef NS_ENUM(NSUInteger, WTRequestCenterCachePolicy) {
    WTRequestCenterCachePolicyNormal,
    WTRequestCenterCachePolicyCacheElseWeb,
    WTRequestCenterCachePolicyOnlyCache,
    WTRequestCenterCachePolicyCacheAndRefresh,
    WTRequestCenterCachePolicyCacheAndWeb
};

@interface WTRequestCenter : NSObject




//请求队列
+(NSOperationQueue*)sharedQueue;
//缓存
+(NSURLCache*)sharedCache;

//设置失效日期,单位是秒
+(void)setExpireTimeInterval:(NSTimeInterval)expireTime;

//失效日期
+(NSTimeInterval)expireTimeInterval;

/*! 清除所有缓存
 
*/
+(void)clearAllCache;


//暂时不可用,目前不会出现请求结束崩溃的现象，所以不需要
//+(void)cancelAllRequest;

//当前缓存大小
+(NSUInteger)currentDiskUsage;

//清除请求的缓存
+(void)removeRequestCache:(NSURLRequest*)request;



//完成回调

#pragma mark - 回调的声明
typedef void (^WTRequestFinishedBlock)(NSURLResponse *respnse,NSData *data);
typedef void (^WTRequestFailedBlock)(NSURLResponse *response,NSError *error);
typedef void (^WTRequestComplectionBlock)(NSURLResponse *response,NSData *data,NSError *error);


//requestFailed
#pragma mark - GET

//普通GET

+(NSURLRequest*)getWithURL:(NSURL*)url
                parameters:(NSDictionary*)parameters
                  finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed;


//用缓存，没有缓存就网络请求

+(NSURLRequest*)getCacheWithURL:(NSURL*)url
                     parameters:(NSDictionary*)parameters
                       finished:(WTRequestFinishedBlock)finished
                         failed:(WTRequestFailedBlock)failed;

//GET

+(NSURLRequest*)getWithURL:(NSURL*)url
                parameters:(NSDictionary *)parameters
                    option:(WTRequestCenterCachePolicy)option
                  finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed;
#pragma mark - POST
//普通POST
+(NSURLRequest*)postWithURL:(NSURL*)url
                 parameters:(NSDictionary*)parameters
                   finished:(WTRequestFinishedBlock)finished
                     failed:(WTRequestFailedBlock)failed;

//POST
+(NSURLRequest*)postWithURL:(NSURL*)url
                 parameters:(NSDictionary *)parameters
                     option:(WTRequestCenterCachePolicy)option
                   finished:(WTRequestFinishedBlock)finished
                     failed:(WTRequestFailedBlock)failed;

 
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
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#endif
#pragma mark - 辅助
//JSON解析
+(id)JSONObjectWithData:(NSData*)data;
+(NSString*)stringWithData:(NSObject*)data;
#pragma mark - URL
//根路径
+(BOOL)setBaseURL:(NSString*)url;
+(NSString *)baseURL;
//实际应用示例
+(NSString*)urlWithIndex:(NSInteger)index;



#pragma mark - Testing Method
+(WTURLRequestOperation*)testGetWithURL:(NSURL*)url
           parameters:(NSDictionary *)parameters
               option:(WTRequestCenterCachePolicy)option
    completionHandler:(WTRequestComplectionBlock)handler;

@end
