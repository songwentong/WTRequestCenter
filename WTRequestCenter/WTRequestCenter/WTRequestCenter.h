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
#import <UIKit/UIKit.h>
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

//停止所有的请求  建议在NavigationController pop之前调用，防止崩溃
//注意:一定要深刻体会它的用法
+(void)cancelAllRequest;

//当前缓存大小，目前有问题，不建议用
+(NSUInteger)currentDiskUsage;

//清除请求的缓存
+(void)removeRequestCache:(NSURLRequest*)request;


#pragma mark - GET

//get请求+Cache
//注意：可以请求本地的文件
+(NSURLRequest*)getWithURL:(NSURL*)url
                parameters:(NSDictionary*)parameters
         completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler;


//无缓存
+(NSURLRequest*)getWithoutCacheURL:(NSURL *)url
                        parameters:(NSDictionary *)parameters
                 completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler;


#pragma mark - POST
//post request (without cache)
+(NSURLRequest*)postWithURL:(NSURL*)url
                 parameters:(NSDictionary*)parameters
          completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler;


//不使用缓存的post请求  (Without Cache)
/*
+(NSURLRequest*)postWithoutCacheURL:(NSURL*)url
                         parameters:(NSDictionary*)parameters
                  completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler;
*/
 
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


@end
