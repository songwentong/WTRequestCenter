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

+(NSBlockOperation*)imageOperationWithURL:(NSString*)url complection:(void(^)(UIImage *image,NSError *error))complection
{
    NSBlockOperation *operation = nil;
    operation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOperation = operation;
    NSMutableURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
//    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    
    __block NSCachedURLResponse *cachedResponse = nil;
    cachedResponse = [[WTNetWorkManager sharedURLcache] cachedResponseForRequest:request];
    if (cachedResponse) {
        NSData *data = cachedResponse.data;
        UIImage *image = [UIImage imageWithData:data];
        
        //如果当前block有持有者,并且operation并未被取消
        if (complection && (![weakOperation isCancelled])) {
            complection(image,nil);
        }
    }else{
        [operation addExecutionBlock:^{
            [[[WTNetWorkManager sharedKit].session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                UIImage *image = nil;
                image = [UIImage imageWithData:data];
                
                if (image) {
                    cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
                    [[WTNetWorkManager sharedURLcache] storeCachedResponse:cachedResponse forRequest:request];
                }
                
                
                //如果当前block有持有者,并且operation并未被取消
                if (complection && (![weakOperation isCancelled])) {
                    complection(image,error);
                }
            }] resume];
        }];
    }
    
    
    return operation;
}



@end
