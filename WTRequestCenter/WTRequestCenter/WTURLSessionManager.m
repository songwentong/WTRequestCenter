//
//  WTURLSessionManager.m
//  WTRequestCenter
//
//  Created by song on 14-8-1.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import "WTURLSessionManager.h"
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)
@interface WTURLSessionManager()
@property (readwrite, nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic,retain) NSOperationQueue *operationQueue;

@property (nonatomic,strong) NSURLSession *URLSession;
@end
@implementation WTURLSessionManager


static WTURLSessionManager *sharedSessionManager;
+(WTURLSessionManager*)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSessionManager = [[WTURLSessionManager alloc] initWithSessionConfiguration:nil];
            
    });
    
    return sharedSessionManager;
}
- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super init];
    if (self) {
        
        if (!configuration) {
            configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        self.sessionConfiguration = configuration;
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.URLSession = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:_operationQueue];
        [_operationQueue setSuspended:NO];
    }
    return self;
}
#pragma mark - Adding Data Tasks to a Session

- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url
                            completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler{
    NSURLSessionDataTask *task = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completionHandler) {
            completionHandler(data,response,error);
        }
    }];
    
    return task;
}
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler{
    NSURLSessionDataTask *task = nil;
    [_URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completionHandler) {
            completionHandler(data,response,error);
        }
    }];
    
    return task;
}

#pragma mark - Adding Download Tasks to a Session
- (NSURLSessionDownloadTask *)downloadTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = nil;
    [_URLSession downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (completionHandler) {
            completionHandler(location,response,error);
        }
    }];
    return task;
}
 

- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler{
    NSURLSessionDownloadTask *task = nil;
    [_URLSession downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (completionHandler) {
            completionHandler(location,response,error);
        }
    }];
    return task;
}


- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler
{
    NSURLSessionDownloadTask *task = nil;
    [_URLSession downloadTaskWithResumeData:resumeData completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (completionHandler) {
            completionHandler(location,response,error);
        }
    }];
    return task;
}

#pragma mark - Adding Upload Tasks to a Session
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromData:(NSData *)bodyData completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    NSURLSessionUploadTask *task = nil;
    [_URLSession uploadTaskWithRequest:request fromData:bodyData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completionHandler) {
            completionHandler(data,response,error);
        }
    }];
    return task;
}

- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    NSURLSessionUploadTask *task = nil;
    [_URLSession uploadTaskWithRequest:request fromFile:fileURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completionHandler) {
            completionHandler(data,response,error);
        }
    }];
    return task;
}

#pragma mark - Just a joke
- (NSString *)debugDescription
{
    return @"just a joke";
}

@end
#endif