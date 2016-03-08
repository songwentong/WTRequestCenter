//
//  NSOperationQueue+Nice.m
//  WTRequestCenter
//
//  Created by SongWentong on 3/8/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "NSOperationQueue+Nice.h"

@implementation NSOperationQueue (Nice)
static NSOperationQueue *globalQueue = nil;
+(instancetype)globalQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalQueue = [[NSOperationQueue alloc] init];
        [globalQueue setSuspended:NO];
    });
    return globalQueue;
}
@end
