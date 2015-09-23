//
//  WTURLSessionManager.h
//  WTRequestCenter
//
//  Created by SongWentong on 8/31/15.
//  Copyright (c) 2015 song. All rights reserved.
//

@import Foundation;

@interface WTURLSessionManager : NSObject
@property (readonly, nonatomic, strong) NSURLSession *session;


-(instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration;

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
@end
