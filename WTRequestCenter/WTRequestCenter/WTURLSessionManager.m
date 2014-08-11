//
//  WTURLSessionManager.m
//  WTRequestCenter
//
//  Created by song on 14-8-1.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import "WTURLSessionManager.h"
@interface WTURLSessionManager()
@property (readwrite, nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic,retain) NSOperationQueue *operationQueue;

@property (nonatomic,strong) NSURLSession *URLSession;
@end
@implementation WTURLSessionManager
- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super init];
    if (self) {
        
        if (configuration) {
            configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        self.sessionConfiguration = configuration;
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.URLSession = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:_operationQueue];
        [_operationQueue setSuspended:NO];
    }
    return self;
}


- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    NSURLSessionDataTask *task = nil;
    [_URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completionHandler) {
            completionHandler(data,response,error);
        }
    }];
    
    return task;
}
@end
