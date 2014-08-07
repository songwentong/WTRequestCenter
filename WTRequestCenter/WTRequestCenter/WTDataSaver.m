//
//  WTDataSaver.m
//  WTRequestCenter
//
//  Created by songwt on 14-8-7.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

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

#pragma mark - 清数据
+(void)removeAllData
{
    [self configureDirectory];
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *array = [manager contentsOfDirectoryAtPath:[WTDataSaver savePath] error:nil];
        for (NSString *string  in array) {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self savePath],string];
            [manager removeItemAtPath:filePath error:nil];
        }
    }];
   
    [blockOperation start];
}

#pragma mark - 其他
+(void)fileSizeComplection:(void(^)(NSInteger size))complection
{
    [self configureDirectory];
//  总大小，单位是字节（Byte）
    __block NSInteger totalSize = 0;

    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSFileManager *manager = [NSFileManager defaultManager];

        NSDirectoryEnumerator* directoryEnumerator =[manager enumeratorAtPath:[self savePath]];
        while ([directoryEnumerator nextObject]) {
            NSLog(@"%@",[directoryEnumerator fileAttributes]);
            NSInteger fileSize = [[[directoryEnumerator fileAttributes] valueForKey:@"NSFileSize"] integerValue];
            totalSize += fileSize;
        }
    }];
    [blockOperation setCompletionBlock:^{
        if (complection) {
            dispatch_async(dispatch_get_main_queue(), ^{
            complection(totalSize);
            });
        }
    }];
    [blockOperation start];
}


#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)
+(void)testiOS7
{
    NSLog(@"iOS7");
}
#endif
@end
