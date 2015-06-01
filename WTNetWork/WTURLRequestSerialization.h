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



@protocol WTURLRequestSerializationProtocol <NSObject>

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(NSDictionary*)parameters
                                        error:(NSError *__autoreleasing *)error;

@end


@interface WTURLRequestSerialization : NSObject <WTURLRequestSerializationProtocol>
/*!
    get the shared request serialization
 */
+(instancetype)sharedRequestSerialization;

/*
 The timeout interval, in seconds, for created requests. The default timeout interval is 60 seconds.
 */
@property (nonatomic) NSTimeInterval timeoutInterval;

/*!
 Returns the value for the HTTP headers set in the request serializer.
 */
- (NSString *)valueForHTTPHeaderField:(NSString *)field;

/*!
 Sets the value for the HTTP headers set in request objects made by the HTTP client. If `nil`, removes the existing value for that header.
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;



/*!
    Creates and returns an initialized URL request with specified values.
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error;
/*!
 
    Creates and returns an initialized URL request with specified values.
 */

-(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
                constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block;







#pragma mark - 其他

/*!
    get responseTime for respnse
 */
+(NSDate*)dateFromCachedURLResponse:(NSCachedURLResponse*)response;


/*
    Returns a request with the specified parameters encoded into a copy of the original request.
 */
- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error;

@end
@protocol WTMultipartFormData

/*!
 Appends the HTTP header `Content-Disposition: file; filename=#{generated filename}; name=#{name}"` and `Content-Type: #{generated mimeType}`, followed by the encoded file data and the multipart form boundary.
 
 The filename and MIME type for this data in the form will be automatically generated, using the last path component of the `fileURL` and system associated MIME type for the `fileURL` extension, respectively.
 
 @param fileURL The URL corresponding to the file whose content will be appended to the form. This parameter must not be `nil`.
 @param name The name to be associated with the specified data. This parameter must not be `nil`.
 @param error If an error occurs, upon return contains an `NSError` object that describes the problem.

 
 */
- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                        error:(NSError * __autoreleasing *)error;

/*!
 Appends the HTTP headers `Content-Disposition: form-data; name=#{name}"`, followed by the encoded data and the multipart form boundary.
 
 @param data The data to be encoded and appended to the form data.
 @param name The name to be associated with the specified data. This parameter must not be `nil`.
 */
- (BOOL)appendPartWithData:(NSData*)data
                      name:(NSString*)name;
@end

@interface WTJSONRequestSerialization : WTURLRequestSerialization

@end

/*
 GET`, `HEAD`, 和 `DELETE` 方法将会把参数加入url中的query中
 */








