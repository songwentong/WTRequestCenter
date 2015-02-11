//
//  WTDataSaver.m
//  WTRequestCenter
//
//  Created by songwt on 14-8-7.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import "WTDataSaver.h"
#import "WTRequestCenter.h"

@implementation WTDataSaver

+(void)clearAllData
{
    NSString *rootDir = [self rootDir];
    [[self sharedDataQueue] addOperationWithBlock:^{
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *array = [[NSFileManager defaultManager] subpathsAtPath:rootDir];
        [array enumerateObjectsUsingBlock:^(NSString *subpath, NSUInteger idx, BOOL *stop)
         {
             NSString *path = [NSString stringWithFormat:@"%@/%@",rootDir,subpath];
             [manager removeItemAtPath:path error:nil];
         }];
    }];

}


static NSOperationQueue *dataQueue = nil;
+(NSOperationQueue*)sharedDataQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataQueue = [[NSOperationQueue alloc] init];
        [dataQueue setMaxConcurrentOperationCount:10];
        [dataQueue setSuspended:NO];
    });
    return dataQueue;
}



+(NSData*)base64EncodedData:(NSData*)data
{

    NSData *result = nil;
    
//    如果是iOS
    #if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        result = [data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else
    {
//        如果小于7.0
    #if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        NSString *string = [data base64Encoding];
        result = [string dataUsingEncoding:NSUTF8StringEncoding];
    #endif
    }
//    如果是苹果电脑
    #elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    if ([WTDataSaver osVersion]>=10.9) {
        result = [data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else
    {
//        如果小于10.9
        #if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9
        NSString *string = [data base64Encoding];
        result = [string dataUsingEncoding:NSUTF8StringEncoding];
        #endif
    }
    #endif
    
    return result;
}

+(NSData*)decodeBase64Data:(NSData*)data
{
//    NS_AVAILABLE(10_9, 7_0);
    NSData *result = nil;

//    如果是iOS
    #if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        result = [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }else
    {
        
//        如果iOS最小编译版本
        #if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        result = [[NSData alloc] initWithBase64Encoding:string];
        #endif
    }
    
//    如果是苹果电脑
    #elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    
    if ([WTDataSaver osVersion]>=10.9) {
        result = [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }else
    {
//        小于10.9
    #if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        result = [[NSData alloc] initWithBase64Encoding:string];
    #endif
    }
    #endif
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
    return [WTRequestCenter JSONObjectWithData:data];
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
    NSNumber *number = @(index);
    
    [self saveData:data withName:[NSString stringWithFormat:@"%@",number]];
}

+(void)saveData:(NSData*)data withName:(NSString*)name
{
    [self saveData:data withName:name completion:nil];
}
+(void)saveData:(NSData *)data withIndex:(NSInteger)index completion:(void (^)())completion
{
    NSNumber *number = @(index);
    NSString *name = [NSString stringWithFormat:@"%@",number];
    [self saveData:data withName:name completion:completion];
}

+(void)saveData:(NSData*)data withName:(NSString*)name completion:(void(^)())completion
{
    [self configureDirectory];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self rootDir],name];
    
    
    [[self sharedDataQueue] addOperationWithBlock:^{
    [data writeToFile:filePath atomically:YES];
    if (completion) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completion();
        }];
    }
    }];

    
   
}




#pragma mark - 取数据
+(NSData*)dataWithName:(NSString*)name
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self rootDir],name];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}


+(void)dataWithIndex:(NSInteger)index completion:(void(^)(NSData*data))completion
{
    NSNumber *number = @(index);
    NSString *name = [NSString stringWithFormat:@"%@",number];
    [self dataWithName:name completion:completion];
}
+(void)dataWithName:(NSString*)name completion:(void(^)(NSData*data))completion
{
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self rootDir],name];

    [self dataWithURL:filePath completionHandler:^(NSData *data) {
        if (completion) {
            completion(data);
        }
    }];

}

+(void)dataWithURL:(NSString*)url
     completionHandler:(void (^)(NSData *data))completion
{
    
    [self configureDirectory];
    if (!url) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (completion) {
                completion(nil);
            }
        }];

    }else
    {
    [[self sharedDataQueue] addOperationWithBlock:^{
        
        NSData *data = [NSData dataWithContentsOfFile:url];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (completion) {
                completion(data);
            }
        }];

    }];
    
    
    }
}

#pragma mark - 清数据

+(void)removeDataWithName:(NSString*)name
{
    [self configureDirectory];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self rootDir],name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath
                                error:nil];
    }
    
    
}


+(void)removeAllData
{
    [self configureDirectory];
    [[WTRequestCenter sharedQueue] addOperationWithBlock:^{
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *array = [manager contentsOfDirectoryAtPath:[WTDataSaver rootDir] error:nil];
        for (NSString *string  in array) {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self rootDir],string];
            [manager removeItemAtPath:filePath error:nil];
        }
    }];
}

#pragma mark - 其他
+(void)fileSizeComplection:(void(^)(NSInteger size))complection
{
    [self configureDirectory];
//  总大小，单位是字节（Byte）
    __block NSInteger totalSize = 0;

    
    [[WTRequestCenter sharedQueue] addOperationWithBlock:^{
        NSFileManager *manager = [NSFileManager defaultManager];
        
        NSDirectoryEnumerator* directoryEnumerator =[manager enumeratorAtPath:[self rootDir]];
        while ([directoryEnumerator nextObject]) {
            
            NSInteger fileSize = [[[directoryEnumerator fileAttributes] valueForKey:@"NSFileSize"] integerValue];
            totalSize += fileSize;
        }
        if (complection) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                complection(totalSize);
            }];
        }
    }];
}

+ (NSString *)debugDescription
{
    return @"just a joke";
}




@end
