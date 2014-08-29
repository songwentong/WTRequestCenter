//
//  WTURLRequestOperation.m
//  WTRequestCenter
//
//  Created by songwt on 14-8-29.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTURLRequestOperation.h"

@implementation WTURLRequestOperation
-(BOOL)isConcurrent
{
    return YES;
}
-(BOOL)isReady
{
    return isReady;
}

-(BOOL)isExecuting
{
    return isExecuting;
}

-(BOOL)isFinished
{
    return isFinished;
}

-(BOOL)isCancelled
{
    return isCancelled;
}

-(void)start
{
    
}
@end
