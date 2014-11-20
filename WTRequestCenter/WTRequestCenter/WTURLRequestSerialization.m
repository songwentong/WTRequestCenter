//
//  WTURLRequestSerialization.m
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/20.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTURLRequestSerialization.h"
@protocol WTMultipartFormData;
@implementation WTURLRequestSerialization
+(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                        parameters:(NSDictionary*)parameters
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    if (parameters && [[parameters allKeys] count]>0) {
        NSMutableString *paramString = [[NSMutableString alloc] init];
        
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
            [paramString appendString:str];
            [paramString appendString:@"&"];
        }];
        if([paramString hasSuffix:@"&"]){
            paramString = [[paramString substringToIndex:[paramString length]-1] mutableCopy];
            
        }
        NSData *postData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:postData];
    }
    return request;
}

+(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                        parameters:(NSDictionary*)parameters
    constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block
{
    NSMutableURLRequest *request = [self POSTRequestWithURL:url parameters:parameters];
    
    
    return request;
}


@end

//  添加数据的协议
@protocol WTMultipartFormData <NSObject>

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                        error:(NSError * __autoreleasing *)error;

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                        error:(NSError * __autoreleasing *)error;

- (void)appendPartWithInputStream:(NSInputStream *)inputStream
                             name:(NSString *)name
                         fileName:(NSString *)fileName
                           length:(int64_t)length
                         mimeType:(NSString *)mimeType;

- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType;


- (void)appendPartWithFormData:(NSData *)data
                          name:(NSString *)name;

- (void)appendPartWithHeaders:(NSDictionary *)headers
                         body:(NSData *)body;

- (void)throttleBandwidthWithPacketSize:(NSUInteger)numberOfBytes
                                  delay:(NSTimeInterval)delay;

@end


@interface WTStreamingMultipartFormData : NSObject <WTMultipartFormData>
- (instancetype)initWithURLRequest:(NSMutableURLRequest *)urlRequest
                    stringEncoding:(NSStringEncoding)encoding;

- (NSMutableURLRequest *)requestByFinalizingMultipartFormData;
@end


//HTTP body 部分
@interface WTHTTPBodyPart : NSObject
@property (nonatomic, assign) NSStringEncoding stringEncoding;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, copy) NSString *boundary;
@property (nonatomic, strong) id body;
@property (nonatomic, assign) unsigned long long bodyContentLength;
@property (nonatomic, strong) NSInputStream *inputStream;

@property (nonatomic, assign) BOOL hasInitialBoundary;
@property (nonatomic, assign) BOOL hasFinalBoundary;

@property (readonly, nonatomic, assign, getter = hasBytesAvailable) BOOL bytesAvailable;
@property (readonly, nonatomic, assign) unsigned long long contentLength;

- (NSInteger)read:(uint8_t *)buffer
        maxLength:(NSUInteger)length;
@end

@interface WTMultipartBodyStream : NSInputStream <NSStreamDelegate>
@property (nonatomic, assign) NSUInteger numberOfBytesInPacket;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, strong) NSInputStream *inputStream;
@property (readonly, nonatomic, assign) unsigned long long contentLength;
@property (readonly, nonatomic, assign, getter = isEmpty) BOOL empty;

- (id)initWithStringEncoding:(NSStringEncoding)encoding;
- (void)setInitialAndFinalBoundaries;
- (void)appendHTTPBodyPart:(WTHTTPBodyPart *)bodyPart;
@end

@interface WTStreamingMultipartFormData ()
@property (readwrite, nonatomic, copy) NSMutableURLRequest *request;
@property (readwrite, nonatomic, assign) NSStringEncoding stringEncoding;
@property (readwrite, nonatomic, copy) NSString *boundary;
@property (readwrite, nonatomic, strong) WTMultipartBodyStream *bodyStream;
@end
