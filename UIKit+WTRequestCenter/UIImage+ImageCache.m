//
//  UIImage+ImageCache.m
//  WTRequestCenter
//
//  Created by SongWentong on 12/31/15.
//  Copyright © 2015 song. All rights reserved.
//

#import "UIImage+ImageCache.h"
#import "WTNetWork.h"
@implementation UIImage (ImageCache)
//static NSURLCache *sharedImageCache = nil;
//+(NSURLCache*)sharedImageCache
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedImageCache = [[NSURLCache alloc] initWithMemoryCapacity:10*1024*1024
//                                                         diskCapacity:1000*1024*1025
//                                                             diskPath:@"WTNetwork Image Cache"];
//        
//    });
//    return sharedImageCache;
//}

+(void)clearAllImages
{
    [[WTNetWorkManager sharedURLcache] removeAllCachedResponses];
}

+(void)removeImageWithURL:(NSString*)url
{
    NSMutableURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    [[WTNetWorkManager sharedURLcache] removeCachedResponseForRequest:request];
}

+(NSBlockOperation*)imageOperationWithURL:(NSString*)url complection:(void(^)(UIImage *image,NSError *error))complection
{
    NSBlockOperation *operation = nil;
    operation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOperation = operation;
    NSMutableURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];

    [operation addExecutionBlock:^{
        [[WTNetWorkManager sharedKit] cachedTaskWithRequest:request finished:^(NSData *data, NSURLResponse *response) {
            UIImage *image = [UIImage imageWithData:data];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (complection && ![weakOperation isCancelled]) {
                    complection(image,nil);
                }
            }];
        } failed:^(NSError *error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (complection && ![weakOperation isCancelled]) {
                    complection(nil,error);
                }
            }];
        }];
    }];

    
    
    
    return operation;
}



@end
