//
//  WTURLRequestSerialization.h
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/24.
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
@protocol WTMultipartFormData;
extern NSTimeInterval const WTURLRequestSerializationTimeoutTimeInterval;

@interface WTURLRequestSerialization : NSObject
//单例
+(instancetype)sharedRequestSerialization;
//超时时长
@property (nonatomic) NSTimeInterval timeoutInterval;

//获得请求头
- (NSString *)valueForHTTPHeaderField:(NSString *)field;

//设置请求头
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;



/*!
    根据给出的方法，URL，参数返回一个请求
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error;
/*!
 
 支持数据上传的POST请求
 */

-(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
                constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block;







#pragma mark - 其他

/*!
    根据给出的响应取到响应时间
 */
+(NSDate*)dateFromCachedURLResponse:(NSCachedURLResponse*)response;


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

@interface WTJSONRequestSerialization : WTURLRequestSerialization
//加上JSON请求
- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error;
@end

/*
 GET`, `HEAD`, 和 `DELETE` 方法将会把参数加入url中的query中
 */








