//
//  NSObject+Nice.m
//  WTRequestCenter
//
//  Created by SongWentong on 3/10/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "NSObject+Nice.h"

@implementation NSObject (Nice)
void perform(dispatch_block_t block , NSTimeInterval delay)
{
    [NSObject performBlock:block afterDelay:delay];
}


+(void)safeSycInMainQueue:(dispatch_block_t)block
{
    if ([NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), block);
    }else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

-(void)safeSycInMainQueue:(dispatch_block_t)block
{
    if ([NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), block);
    }else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

+(void)performBlock:(dispatch_block_t)block afterDelay:(NSTimeInterval)delay
{
    
    [self performBlock:block
               inQueue:dispatch_get_main_queue()
            afterDelay:delay];
}


+(void)performBlock:(dispatch_block_t)block inQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay
{
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, delay*NSEC_PER_SEC);
    dispatch_after(t, queue, ^{
        if (block) {
            block();
        }
    });
}
@end
