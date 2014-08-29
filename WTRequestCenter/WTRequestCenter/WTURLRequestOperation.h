//
//  WTURLRequestOperation.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-29.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTURLRequestOperation : NSOperation <NSURLConnectionDataDelegate>
{
    BOOL isReady;
    BOOL isExecuting;
    BOOL isFinished;
    BOOL isCancelled;
}

@end
