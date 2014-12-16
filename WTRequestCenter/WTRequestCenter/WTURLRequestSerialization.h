//
//  WTURLRequestSerialization.h
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/24.
//  Copyright (c) 2014年 song. All rights reserved.
//
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
@protocol WTMultipartFormData;



#pragma mark - 静态方法
/**
    请求超时时间
 */
extern NSTimeInterval WTURLRequestSerializationTimeoutTimeInterval;



@interface WTURLRequestSerialization : NSObject
/*!
 单例的实例
 */
+(instancetype)sharedRequestSerialization;

//超时时间
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/*!
    设置请求头
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
/*!
    获得请求头
 */
- (NSString *)valueForHTTPHeaderField:(NSString *)field;

/*!

 GET请求
 */
+(NSMutableURLRequest*)GETRequestWithURL:(NSString*)url
                              parameters:(NSDictionary*)parameters;
-(NSMutableURLRequest*)GETRequestWithURL:(NSString*)url
                              parameters:(NSDictionary*)parameters;
/*!
 
 POST请求
 */
+(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters;
-(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters;


/*!
 
 支持数据上传的POST请求
 */
+(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
                constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block;
-(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
                constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block;


/*!
    PUT请求
 */
+(NSMutableURLRequest*)PUTRequestWithURL:(NSString*)url
                              parameters:(NSDictionary*)parameters;
-(NSMutableURLRequest*)PUTRequestWithURL:(NSString*)url
                              parameters:(NSDictionary*)parameters;
/*!
    To Do head请求
 */
+(NSMutableURLRequest*)HEADRequestWithURL:(NSString*)url
                              parameters:(NSDictionary*)parameters;


#pragma mark - 实例方法

@end
@protocol WTMultipartFormData

/*!
    暂未完成
 */
- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                        error:(NSError * __autoreleasing *)error;

/*!
    数据上传协议
 */
- (BOOL)appendPartWithData:(NSData*)data
                      name:(NSString*)name;
@end













