//
//  WTURLConnectionOperation.h
//  WTRequestCenter
//
//  Created by song on 14-8-1.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter
/*
    施工中🚧，你看到了不改看到的东西，😄，这个东西暂时不可以用，谢谢
 */
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
@property (readonly, nonatomic, strong) NSMutableData *responseData;

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
