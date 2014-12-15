//
//  WTURLRequestSerialization.h
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/24.
//  Copyright (c) 2014年 song. All rights reserved.
//

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













