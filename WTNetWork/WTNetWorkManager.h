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
/*!
    根据请求方法,URL和参数创建一个请求对象
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error;


/*!
    根据url,参数和对应的数据来创建一个请求对象
 
 body 中存的是NSDictionary,包含4个内容
 name 是名字
 filename 是文件名
 contentType 是内容类型
 content 是内容
 
 目前没有做的是同一个name对应多个文件,那个做起来比较复杂,没啥需求,就不做了.
 */
-(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
                                     body:(NSArray*)body;
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