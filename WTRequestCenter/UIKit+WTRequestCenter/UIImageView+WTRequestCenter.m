//
//  UIImageView+WTImageCache.m
//  WTRequestCenter
//
//  Created by song on 14-7-19.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import "UIImageView+WTRequestCenter.h"
#import "WTRequestCenter.h"
#import "WTRequestCenterMacro.h"
@implementation UIImageView (WTRequestCenter)
- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    self.image = placeholder;
    if (url) {
        __weak UIImageView *wself    = self;
        [WTRequestCenter getWithURL:url parameters:nil completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//从这里开始已经是主线程了
            
            if (data) {
                [[WTRequestCenter sharedQueue] addOperationWithBlock:^{
                    UIImage *image = [UIImage imageWithData:data];
                    
                    if (image) {
                        if (!wself) return;
                        __strong UIImageView *strongSelf = wself;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                        strongSelf.image = image;
                        [strongSelf setNeedsDisplay];
                        });
                    }
                }];
                

            }
        }];
    }else
    {
        
    }
}
@end
