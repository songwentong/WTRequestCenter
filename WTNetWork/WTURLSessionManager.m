//
//  WTURLSessionManager.m
//  WTRequestCenter
//
//  Created by SongWentong on 8/31/15.
//  Copyright (c) 2015 song. All rights reserved.
//

#import "WTURLSessionManager.h"
@interface WTURLSessionManager()

@property (readwrite, nonatomic, strong) NSURLSession *session;

@end
@implementation WTURLSessionManager

static NSOperationQueue *sessionCreationQueue = nil;
+(NSOperationQueue*)sessionCreationQueue{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionCreationQueue = [NSOperationQueue new];
        [sessionCreationQueue setSuspended:NO];
    });
    return sessionCreationQueue;
}


-(instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super init];
    if (self) {
        
    }
    
    if (!configuration) {
        configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:sessionCreationQueue];
    

    return self;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    __block NSURLSessionDataTask *dataTask = nil;
//    [[WTURLSessionManager sessionCreationQueue] addOperationWithBlock:^{
        dataTask = [self.session dataTaskWithRequest:request completionHandler:completionHandler];
//    }];
    
    return dataTask;
}

@end
