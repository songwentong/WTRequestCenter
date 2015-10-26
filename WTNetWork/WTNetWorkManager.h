//
//  WTNetWorkManager.h
//  WTRequestCenter
//
//  Created by SongWentong on 10/26/15.
//  Copyright © 2015 song. All rights reserved.
//

#import <Foundation/Foundation.h>

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