//
//  WTDataSaver.m
//  WTRequestCenter
//
//  Created by songwt on 14-8-7.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTDataSaver.h"

@implementation WTDataSaver
#pragma mark - 保存路径
+(NSString*)savePath
{
    NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/WTDataSaver",NSHomeDirectory()];
    return path;
}

//创建文件夹
+(void)configureDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL fileExists = [fileManager fileExistsAtPath:[WTDataSaver savePath] isDirectory:nil];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:[WTDataSaver savePath] withIntermediateDirectories:NO attributes:nil error:nil];
    }
}
#pragma mark - 存数据
+(void)saveData:(NSData*)data withIndex:(NSInteger)index
{
    [self saveData:data withName:[NSString stringWithFormat:@"%d",index]];
}

+(void)saveData:(NSData*)data withName:(NSString*)name
{
    [self saveData:data withName:name completion:nil];
}
+(void)saveData:(NSData *)data withIndex:(NSInteger)index completion:(void (^)())completion
{
    NSString *name = [NSString stringWithFormat:@"%d",index];
    [self saveData:data withName:name completion:completion];
}
+(void)saveData:(NSData*)data withName:(NSString*)name completion:(void(^)())completion
{
    [self configureDirectory];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self savePath],name];
    NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
        [data writeToFile:filePath atomically:YES];
    }];
    [block setCompletionBlock:^{
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    }];
    [block start];
}


#pragma mark - 取数据
+(NSData*)dataWithIndex:(NSInteger)index
{
    NSData *data = nil;
    data = [self dataWithName:[NSString stringWithFormat:@"%d",index]];
    return data;
}


+(NSData*)dataWithName:(NSString*)name
{
    
    [self configureDirectory];
    NSData *data = nil;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self savePath],name];
    data = [NSData dataWithContentsOfFile:filePath];
    return data;
}
+(void)dataWithIndex:(NSInteger)index completion:(void(^)(NSData*data))completion
{
    NSString *name = [NSString stringWithFormat:@"%d",index];
    [self dataWithName:name completion:completion];
}
+(void)dataWithName:(NSString*)name completion:(void(^)(NSData*data))completion
{
    [self configureDirectory];
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
