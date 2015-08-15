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

@class WTURLRequestSerialization;
@protocol WTMultipartFormData;
@class WTURLRequestOperation;
@class Reachability;
@protocol WTURLRequestSerializationProtocol;

#if ( ( defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090) || \
( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 ) )

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


//call back block
typedef void (^WTRequestFinishedBlock)(NSURLResponse *response,NSData *data);
typedef void (^WTRequestFailedBlock)(NSURLResponse *response,NSError *error);
typedef void (^WTRequestComplectionBlock)(NSURLResponse *response,NSData *data,NSError *error);
typedef void (^WTDownLoadProgressBlock)(NSUInteger bytesRead,long long totalBytesRead,long long totalBytesExpectedToRead);




#if !__has_feature(objc_arc)
#error WTNetwork must be built with ARC.
// You can turn on ARC for only WTNetwork files by adding -fobjc-arc to the build phase for each of its files.
#endif

@interface WTRequestCenter : NSObject

/*!
    生成一个请求对象
 */
+(WTRequestCenter*)requestCenter;
/*!
    单例
 */
+(WTRequestCenter*)sharedCenter;



/*!
 Performs an asynchronous load of the given
 request. When the request has completed or failed,
 the block will be executed from the context of the
 main NSOperationQueue.
 */
+(void)doURLRequest:(NSURLRequest*)request
           finished:(WTRequestFinishedBlock)finished
             failed:(WTRequestFailedBlock)failed;



#pragma mark - 安全请求


/*!
 Performs an asynchronous get request of the given
 url,parameters. When the request has completed or failed,
 corresponding block will be executed
 */
+(NSURLRequest*)getWithURL:(NSString*)url
                parameters:(NSDictionary*)parameters
                  finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed;


/*!
    推荐的新缓存方法，建议使用
 */
+(NSURLRequest*)GETUsingCache:(NSString*)url
                   parameters:(NSDictionary *)parameters
                     finished:(WTRequestFinishedBlock)finished
                       failed:(WTRequestFailedBlock)failed;


/*!
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
 Performs an asynchronous post request of the given
 url,parameters. When the request has completed or failed,
 corresponding block will be executed，is there is a local
 response,it will be used.
 */
+(NSURLRequest*)postWithURL:(NSString*)url
                 parameters:(NSDictionary*)parameters
  constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block
                   finished:(WTRequestFinishedBlock)finished
                     failed:(WTRequestFailedBlock)failed;


/*!
 Performs an asynchronous post request of the given
 url,parameters. When the request has completed or failed,
 corresponding block will be executed，is there is a local
 response,it will be used.
 */
+(NSURLRequest*)putWithURL:(NSString*)url
                parameters:(NSDictionary*)parameters
                  finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed;


/*!
 Performs an asynchronous post request of the given
 url,parameters. When the request has completed or failed,
 corresponding block will be executed，is there is a local
 response,it will be used.
 */
+(NSURLRequest*)deleteWithURL:(NSString*)url
                   parameters:(NSDictionary*)parameters
                     finished:(WTRequestFinishedBlock)finished
                       failed:(WTRequestFailedBlock)failed;


/*!
 Performs an asynchronous post request of the given
 url,parameters. When the request has completed or failed,
 corresponding block will be executed，is there is a local
 response,it will be used.
 */
+(NSURLRequest*)headWithURL:(NSString*)url
                 parameters:(NSDictionary*)parameters
                   finished:(WTRequestFinishedBlock)finished
                     failed:(WTRequestFailedBlock)failed;

#pragma mark - 实例方法（1.0）
/**
 创建一个 WTURLRequestOperation对象（没有执行）
 
 
 note: 并没有执行
 */
- (WTURLRequestOperation *)HTTPRequestOperationWithHTTPMethod:(NSString *)method
                                                    URLString:(NSString *)URLString
                                                   parameters:(NSDictionary*)parameters
                                                     finished:(void (^)(WTURLRequestOperation *operation, NSData *data))finished
                                                       failed:(void (^)(WTURLRequestOperation *operation, NSError *error))failed;

/**
 创建并且执行一个 WTURLRequestOperation对象 （GET 请求）
 */
-(WTURLRequestOperation*)GET:(NSString*)urlString
                  parameters:(NSDictionary*)parameters
                    finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                      failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed;

/**
 GET + 缓存策略
 */
-(WTURLRequestOperation*)GETUsingCache:(NSString*)urlString
                            parameters:(NSDictionary*)parameters
                              finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                                failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed;

/**
 HEAD
 */
-(WTURLRequestOperation*)HEAD:(NSString*)urlString
                   parameters:(NSDictionary*)parameters
                     finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                       failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed;

/**
 POST
 */
-(WTURLRequestOperation*)POST:(NSString*)urlString
                   parameters:(NSDictionary*)parameters
                     finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                       failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed;
/**
 用POST请求，创建并执行一个 WTURLRequestOperation对象。
 
 */
-(WTURLRequestOperation*)POST:(NSString*)urlString
                   parameters:(NSDictionary*)parameters
    constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block
                     finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                       failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed;
/*!
 PUT方法
 */
-(WTURLRequestOperation*)PUT:(NSString*)urlString
                  parameters:(NSDictionary*)parameters
                    finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                      failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed;

/*!
 DELETE方法
 */
-(WTURLRequestOperation*)DELETE:(NSString*)urlString
                     parameters:(NSDictionary*)parameters
                       finished:(void(^)( WTURLRequestOperation*operation,NSData*data))finished
                         failed:(void(^)( WTURLRequestOperation*operation,NSError *error))failed;


#pragma mark - 其他
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
+(void)removeCachedResponseForRequest:(NSURLRequest*)request;


#pragma mark - 请求开始和结束的消息
//请求成功的消息，线程安全，可以传空
+(void)sendRequestStartNotificationWithRequest:(NSURLRequest *)request;
//请求失败的消息，线程安全，所有参数可传空
+(void)sendRequestCompleteNotificationWithRequest:(NSURLRequest*)request
                                         response:(NSURLResponse*)response
                                             data:(NSData*)data
                                            error:(NSError*)error;


#pragma mark - 请求开始和结束的输出
/*!
 请求开始的输出
 */
+(void)logRequestStart:(NSURLRequest*)request;


/*!
 请求结束的输出
 */
+(void)logRequesEndWithRequest:(NSURLRequest*)request
                      response:(NSURLResponse*)response
                         error:(NSError*)error;



#pragma mark - 属性

//请求间隔,默认为0,每次请求都有效
@property (nonatomic) NSTimeInterval effectiveReqeustTimeInterval;

//根据请求获得一个信息,看请求是否在有效期内
+(NSDictionary*)effectiveResponseForRequest:(NSURLRequest*)request;

/*!
    凭据
 */
@property (nonatomic, strong) NSURLCredential *credential;


/*!
    请求生成类
 */
@property (nonatomic, strong) WTURLRequestSerialization <WTURLRequestSerializationProtocol> * requestSerializer;

/*!
    自身线程
 */
@property (nonatomic, strong) NSOperationQueue *operationQueue;




#pragma mark - 辅助
// convert json data to object
+(id)JSONObjectWithData:(NSData*)data;
+(NSString*)stringWithData:(NSObject*)data;

// convert object to json data
+(NSData*)dataFromJSONObject:(id)object;

#pragma mark - 延时的方法
/*!
 在daley秒后执行一个block
 */
void perform(dispatch_block_t block , NSTimeInterval delay);
/*!
 在daley秒后执行一个block
 */
+(void)performBlock:(dispatch_block_t)block
         afterDelay:(NSTimeInterval)delay;
/*!
 在daley秒后执行一个block
 */
+(void)performBlock:(dispatch_block_t)block
            inQueue:(dispatch_queue_t)queue
         afterDelay:(NSTimeInterval)delay;

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


/*!
    Debug模式
 */
extern BOOL const WTRequestCenterDebugMode;
