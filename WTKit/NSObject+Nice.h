//
//  NSObject+Nice.h
//  WTRequestCenter
//
//  Created by SongWentong on 3/10/16.
//  Copyright © 2016 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Nice)
/*!
    修改了NSLog,只用于DEBUG的时候输出
 */

/*!
    用于DEBUG模式下的操作
 */
void DEBUGBlock(dispatch_block_t block);
/*!
    用于非DEBUG模式下的操作
 */
void ReleaseBlock(dispatch_block_t block);
/*!
    安全的回到主线程同步执行block
 */
void safeSyncInMainQueue( dispatch_block_t block);

+(void)performBlock:(dispatch_block_t)block afterDelay:(NSTimeInterval)delay;
+(void)performBlock:(dispatch_block_t)block inQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay;
+(id)forEach:(id)obj replaceNullWith:(id(^)(id key))block;
@end
