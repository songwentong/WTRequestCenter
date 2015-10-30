//
//  WTNetWorkManager.h
//  WTRequestCenter
//
//  Created by SongWentong on 10/26/15.
//  Copyright © 2015 song. All rights reserved.
//

@import Foundation;

@interface WTNetWorkManager : NSObject
+(instancetype)sharedKit;
@property (readonly, nonatomic, strong) NSURLSession *session;
-(NSOperationQueue*)operationQueue;

@end

@interface WTNetWorkManager(CreatRequest)
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error;


/*!
    未完成...
    根据url,参数和对应的数据来创建一个请求对象
    body的key是字符串,value是对应的NSData
 */
-(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
                                     body:(NSDictionary*)body;
@end

@interface WTNetWorkManager(GCD)
void perform(dispatch_block_t block , NSTimeInterval delay);
+(void)performBlock:(dispatch_block_t)block afterDelay:(NSTimeInterval)delay;
+(void)performBlock:(dispatch_block_t)block inQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay;

@end
/**
 Posted when an operation begins executing.
 */
extern NSString * const WTNetworkingOperationDidStartNotification;

/**
 Posted when an operation finishes.
 */
extern NSString * const WTNetworkingOperationDidFinishNotification;