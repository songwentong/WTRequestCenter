//
//  DataWriteOpeation.m
//  WTRequestCenter
//
//  Created by songwt on 14-8-29.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTDataWriteOpeation.h"
@interface WTDataWriteOpeation()
{

}

@property (nonatomic,retain,readwrite)NSData *dataToWrite;
@property (nonatomic,readwrite,retain)NSString *filePath;
@end
@implementation WTDataWriteOpeation
#pragma mark - NSOperation
- (instancetype)initWithData:(NSData*)data andFilePath:(NSString*)filePath
{
    self = [super init];
    if (self) {
        self.dataToWrite = data;
        self.filePath = filePath;
        isReady = YES;
        isExecuting = NO;
        isFinished = NO;
        isCancelled = NO;
    }
    return self;
}
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
    [_dataToWrite writeToFile:_filePath atomically:YES];
    isFinished = YES;
    isExecuting = NO;
}


@end
