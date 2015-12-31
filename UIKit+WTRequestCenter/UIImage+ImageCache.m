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

+(NSBlockOperation*)imageOperationWithURL:(NSString*)url complection:(void(^)(UIImage *image))complection
{
    NSBlockOperation *operation = nil;
    operation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOperation = operation;
    NSMutableURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    [operation addExecutionBlock:^{
        [[[WTNetWorkManager sharedKit].session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            UIImage *image = nil;
            image = [UIImage imageWithData:data];
            if (complection) {
                if (![weakOperation isCancelled]) {
                    complection(image);
                }
            }
        }] resume];
    }];
    
    return operation;
}

@end
