//
//  WTURLConnectionOperation.h
//  WTRequestCenter
//
//  Created by song on 14-8-1.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTURLConnectionOperation : NSOperation <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

/**
 请求
 */
@property (readonly, nonatomic, strong) NSURLRequest *request;

/**
 响应
 */
@property (readonly, nonatomic, strong) NSURLResponse *response;


/**
 错误
 */
@property (readonly, nonatomic, strong) NSError *error;

/**
 响应的数据
 */
@property (readonly, nonatomic, strong) NSData *responseData;

/**
 响应的字符串
 */
@property (readonly, nonatomic, copy) NSString *responseString;

/**
 初始化
 
 */
- (instancetype)initWithRequest:(NSURLRequest *)urlRequest;


/**
 暂停
 */
- (void)pause;

/**
 状态
 */
- (BOOL)isPaused;

/**
 继续
 */
- (void)resume;
























@end
