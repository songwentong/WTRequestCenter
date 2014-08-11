//
//  WTURLSessionManager.h
//  WTRequestCenter
//
//  Created by song on 14-8-1.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

//  如果需要适配iOS6以及以前的版本，请删除这个文件
/*

 */

#import <Foundation/Foundation.h>
@interface WTURLSessionManager : NSObject

@property (readonly,nonatomic,strong) NSURLSession *URLSession;
@property (readonly,nonatomic,strong) NSURLSessionConfiguration *sessionConfiguration;

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration;

#pragma mark - Adding Data Tasks to a Session
- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url
                        completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;


#pragma mark - Adding Download Tasks to a Session
- (NSURLSessionDownloadTask *)downloadTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler;

- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler;

- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler;


#pragma mark - Adding Upload Tasks to a Session
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromData:(NSData *)bodyData completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
@end
