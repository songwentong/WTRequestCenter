//
//  DataWriteOpeation.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-29.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTDataWriteOpeation : NSOperation
{
    BOOL isReady;
    BOOL isExecuting;
    BOOL isFinished;
    BOOL isCancelled;
}
- (instancetype)initWithData:(NSData*)data andFilePath:(NSString*)filePath;
@property (nonatomic,readonly,retain)NSData *dataToWrite;
@property (nonatomic,readonly,retain)NSString *filePath;


@end
