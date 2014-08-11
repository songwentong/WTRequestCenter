//
//  WTURLSessionManager.h
//  WTRequestCenter
//
//  Created by song on 14-8-1.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

//  如果需要适配iOS6以及以前的版本，请移除这块的东西
/*
 施工中🚧，你看到了不改看到的东西，😄，这个东西暂时不可以用，谢谢
 */

#import <Foundation/Foundation.h>
@interface WTURLSessionManager : NSObject

@property (readonly,nonatomic,strong) NSURLSession *URLSession;
@property (readonly,nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration;
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
@end
