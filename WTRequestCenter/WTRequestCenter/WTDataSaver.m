//
//  WTDataSaver.m
//  WTRequestCenter
//
//  Created by songwt on 14-8-7.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTDataSaver.h"

@implementation WTDataSaver
+(NSString*)savePath
{
    NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/WTDataSaver",NSHomeDirectory()];
    return path;
}
+(void)configureDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL fileExists = [fileManager fileExistsAtPath:[WTDataSaver savePath] isDirectory:nil];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:[WTDataSaver savePath] withIntermediateDirectories:NO attributes:nil error:nil];
    }
}
+(void)saveData:(NSData*)data withIndex:(NSInteger)index
{
    [self saveData:data withName:[NSString stringWithFormat:@"%d",index]];
}
+(NSData*)dataWithIndex:(NSInteger)index
{
    NSData *data = nil;
    data = [self dataWithName:[NSString stringWithFormat:@"%d",index]];
    return data;
}
+(void)saveData:(NSData*)data withName:(NSString*)name
{
    [self configureDirectory];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self savePath],name];
    NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
        [data writeToFile:filePath atomically:YES];
    }];
    [block start];
}

+(NSData*)dataWithName:(NSString*)name
{
    NSData *data = nil;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self savePath],name];
    data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

+(void)dataWithName:(NSString*)name completion:(void(^)(NSData*data))completion
{
    __block NSData *data = nil;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self savePath],name];
    NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
        data = [NSData dataWithContentsOfFile:filePath];
    }];
    /*
    [block setCompletionBlock:^{
        
    }];*/
    
    block.completionBlock = ^{
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
            completion(data);
            });
        }
    };
    [block start];
}


@end
