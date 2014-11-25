//
//  WTURLRequestSerialization.h
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/24.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WTMultipartFormData;
@interface WTURLRequestSerialization : NSObject
//POST请求
+(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters;


//支出数据上传

+(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
                constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block;
@end
@protocol WTMultipartFormData
- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                        error:(NSError * __autoreleasing *)error;
- (BOOL)appendPartWithData:(NSData*)data
                      name:(NSString*)name;
@end
