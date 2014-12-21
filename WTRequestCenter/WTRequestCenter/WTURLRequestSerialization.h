//
//  WTURLRequestSerialization.h
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/24.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WTMultipartFormData;
extern NSTimeInterval const WTURLRequestSerializationTimeoutTimeInterval;
@interface WTURLRequestSerialization : NSObject

@property (nonatomic) NSTimeInterval timeoutInterval;

/*!

 GET请求
 */
+(NSMutableURLRequest*)GETRequestWithURL:(NSString*)url
                              parameters:(NSDictionary*)parameters;

/*!
 
 POST请求
 */
+(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters;



/*!
 
 支持数据上传的POST请求
 */
+(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
                constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block;



/*!
    PUT请求
 */
+(NSMutableURLRequest*)PUTRequestWithURL:(NSString*)url
                              parameters:(NSDictionary*)parameters;
/*!
    To Do head请求
 */
+(NSMutableURLRequest*)HEADRequestWithURL:(NSString*)url
                              parameters:(NSDictionary*)parameters;








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













