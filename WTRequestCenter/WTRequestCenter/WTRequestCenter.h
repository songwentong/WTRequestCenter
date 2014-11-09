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
 
 使用方法很简单，只需要传URL和参数就可以了。

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
 
 @constant WTRequestCenterCachePolicyNormal
 基本请求，直接访问url，取得数据
 
 @constant WTRequestCenterCachePolicyCacheElseWeb
 查看本地是否有缓存，如果有就使用，不管失效日期，
 如果缓存中没有，就访问url
 
 @constant WTRequestCenterCachePolicyOnlyCache
 只取本地的数据，如果本地数据为空也不访问网络
 
 @constant WTRequestCenterCachePolicyCacheAndRefresh
 本地获取一次，网络获取一次。
 如果本地有数据，网络获取不回调，如果本地没有数据，网络获取会回调
 
 
 @constant WTRequestCenterCachePolicyCacheAndWeb
 本地获取一次，网络获取一次，都会回调。
 注意：这种情况非常少见，只有调用网页的时候可能会用得到。
 
 */

typedef NS_ENUM(NSUInteger, WTRequestCenterCachePolicy) {
    WTRequestCenterCachePolicyNormal,
    WTRequestCenterCachePolicyCacheElseWeb,
    WTRequestCenterCachePolicyOnlyCache,
    WTRequestCenterCachePolicyCacheAndRefresh,
    WTRequestCenterCachePolicyCacheAndWeb
};


//回调声明
typedef void (^WTRequestFinishedBlock)(NSURLResponse *response,NSData *data);
typedef void (^WTRequestFailedBlock)(NSURLResponse *response,NSError *error);
typedef void (^WTRequestComplectionBlock)(NSURLResponse *response,NSData *data,NSError *error);

@interface WTRequestCenter : NSObject



/*!
 执行一个NSURLRequest请求
 */
+(void)doURLRequest:(NSURLRequest*)request
           finished:(WTRequestFinishedBlock)finished
             failed:(WTRequestFailedBlock)failed;
#pragma mark - GET

//普通GET
/*!
 根据给出的url和参数执行一个GET请求，当请求成功或者失败，对应的回调
 将会被执行.
 Performs an asynchronous get request of the given
 url,parameters. When the request has completed or failed,
 corresponding block will be executed
 */
+(NSURLRequest*)getWithURL:(NSString*)url
                parameters:(NSDictionary*)parameters
                  finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed;



/*!
 根据给出的url和参数执行一个GET请求，当请求成功或者失败，对应的回调
 将会被执行,如果本地有缓存，将会使用缓存
 Performs an asynchronous get request of the given
 url,parameters. When the request has completed or failed,
 corresponding block will be executed，is there is a local
 response,it will be used.
 */
+(NSURLRequest*)getCacheWithURL:(NSString*)url
                     parameters:(NSDictionary*)parameters
                       finished:(WTRequestFinishedBlock)finished
                         failed:(WTRequestFailedBlock)failed;


/*!
 根据给出的url,参数和缓存策略执行一个GET请求，当请求成功或者失败，对应的回调
 将会被执行
 Performs an asynchronous get request of the given
 url,parameters，cache pilicy. When the request has completed or failed,
 corresponding block will be executed，is there is a local
 response,it will be used.
 */
+(NSURLRequest*)getWithURL:(NSString*)url
                parameters:(NSDictionary *)parameters
                    option:(WTRequestCenterCachePolicy)option
                  finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed;
#pragma mark - POST
/*!
 根据给出的url，参数，执行一个POST请求，
 当请求执行成功或者失败，对应的回调将会被执行
 Performs an asynchronous post request of the given
 url,parameters. When the request has completed or failed,
 corresponding block will be executed，is there is a local
 response,it will be used.
 */
+(NSURLRequest*)postWithURL:(NSString*)url
                 parameters:(NSDictionary*)parameters
                   finished:(WTRequestFinishedBlock)finished
                     failed:(WTRequestFailedBlock)failed;

/*!
    不推荐用这个方法。
 */
+(NSURLRequest*)postWithURL:(NSString*)url
                 parameters:(NSDictionary *)parameters
                     option:(WTRequestCenterCachePolicy)option
                   finished:(WTRequestFinishedBlock)finished
                     failed:(WTRequestFailedBlock)failed;



/*!
 shared Call Back Queue
 */
+(NSOperationQueue*)sharedQueue;
/*!
 shared Cache
 */
+(NSURLCache*)sharedCache;

/*!
 Clears the receiver’s cache, removing all stored cached URL responses.
 */
+(void)clearAllCache;


/*!
 @method currentDiskUsage
 current Disk Usage
 */

+(NSUInteger)currentDiskUsage;

//当前缓存用量，直接根据大小来调节单位的显示，KB，MB，GB，TB，PB，EB
+(NSString*)currentDiskUsageString;


/*!
 根据请求清除被保存的的缓存
 Removes the NSCachedURLResponse from the cache that is
 stored using the given request.
 */
+(void)removeRequestCache:(NSURLRequest*)request;

#pragma mark - Image
//图片上传  Upload
+(void)upLoadImageWithURL:(NSString*)url
                     data:(NSData *)data
                 fileName:(NSString*)fileName
        completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler;

//多图片上传
+(void)upLoadImageWithURL:(NSString*)url
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

//GET
+(WTURLRequestOperation*)testGetWithURL:(NSString *)url
                             parameters:(NSDictionary *)parameters
                               finished:(WTRequestFinishedBlock)finished
                                 failed:(WTRequestFailedBlock)failed;

+(WTURLRequestOperation*)testGetWithURL:(NSString*)url
                             parameters:(NSDictionary *)parameters
                                 option:(WTRequestCenterCachePolicy)option
                               finished:(WTRequestFinishedBlock)finished
                                 failed:(WTRequestFailedBlock)failed;

//加上进度
+(WTURLRequestOperation*)testGetWithURL:(NSString*)url
                             parameters:(NSDictionary *)parameters
                                 option:(WTRequestCenterCachePolicy)option
                               progress:(WTDownLoadProgressBlock)progress
                               finished:(WTRequestFinishedBlock)finished
                                 failed:(WTRequestFailedBlock)failed;

//POST
+(WTURLRequestOperation*)testPOSTWithURL:(NSString*)url
                              parameters:(NSDictionary *)parameters
                                finished:(WTRequestFinishedBlock)finished
                                  failed:(WTRequestFailedBlock)failed;
@end

///--------------------
/// @name Notifications
///--------------------


/**
 Posted when an operation begins executing.
 */
extern NSString * const WTNetworkingOperationDidStartNotification;

/**
 Posted when an operation finishes.
 */
extern NSString * const WTNetworkingOperationDidFinishNotification;
