//
//  WTDataSaver.m
//  WTRequestCenter
//
//  Created by songwt on 14-8-7.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import "WTDataSaver.h"

@implementation WTDataSaver

#pragma mark - 工具
+(CGFloat)osVersion
{
    CGFloat version = 0;
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    UIDevice *currentDevice = [UIDevice currentDevice];
    version = currentDevice.systemVersion.floatValue;
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    NSDictionary * sv = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"];
    version = [[sv objectForKey:@"ProductVersion"] floatValue];
#endif
    
    return version;
}
+(NSData*)base64EncodedData:(NSData*)data
{

    NSData *result = nil;
    #if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if ([WTDataSaver osVersion]>=7.0) {
        result = [data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else
    {
    #if __IPHONE_OS_VERSION_MIN_REQUIRED <__IPHONE_7_0
        NSString *string = [data base64Encoding];
        result = [string dataUsingEncoding:NSUTF8StringEncoding];
    #endif
    }
    #elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    if ([WTDataSaver osVersion]>=10.9) {
        result = [data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else
    {
        NSString *string = [data base64Encoding];
        result = [string dataUsingEncoding:NSUTF8StringEncoding];
    }
    #endif
    
    return result;
}

+(NSData*)decodeBase64Data:(NSData*)data
{
//    NS_AVAILABLE(10_9, 7_0);
    NSData *result = nil;
    if ([WTDataSaver osVersion]>=7.0) {
        result = [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }else
    {
        #if __IPHONE_OS_VERSION_MIN_REQUIRED <__IPHONE_7_0
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        result = [[NSData alloc] initWithBase64Encoding:string];
    #endif  
    }
    
    
    return result;
}


#pragma mark - 对象转换
+(NSData*)dataWithJSONObject:(id)obj
{
    NSData *data = nil;
    if ([NSJSONSerialization isValidJSONObject:obj]) {
        data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    }
    return data;
}

+(id)JSONObjectWithData:(NSData*)data
{
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return obj;
}

#pragma mark - 保存路径
//跟目录
+(NSString*)rootDir
{
    NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/WTDataSaver",NSHomeDirectory()];
    return path;
}

//创建文件夹
+(void)configureDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL fileExists = [fileManager fileExistsAtPath:[WTDataSaver rootDir] isDirectory:nil];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:[WTDataSaver rootDir] withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

+(NSString*)pathWithName:(NSString*)name
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self rootDir],name];
    return filePath;
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
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self rootDir],name];
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
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self rootDir],name];
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
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self rootDir],name];
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
        NSArray *array = [manager contentsOfDirectoryAtPath:[WTDataSaver rootDir] error:nil];
        for (NSString *string  in array) {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self rootDir],string];
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

        NSDirectoryEnumerator* directoryEnumerator =[manager enumeratorAtPath:[self rootDir]];
        while ([directoryEnumerator nextObject]) {
//            NSLog(@"%@",[directoryEnumerator fileAttributes]);
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

+ (NSString *)debugDescription
{
    return @"just a joke";
}

@end
