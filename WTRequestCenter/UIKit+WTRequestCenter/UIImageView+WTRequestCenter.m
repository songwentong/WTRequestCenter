//
//  UIImageView+WTImageCache.m
//  WTRequestCenter
//
//  Created by song on 14-7-19.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import "UIImageView+WTRequestCenter.h"
#import "WTRequestCenter.h"

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}
@implementation UIImageView (WTRequestCenter)
- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    self.image = placeholder;
    if (url) {
        __weak UIImageView      *wself    = self;
        [WTRequestCenter getWithURL:url parameters:nil completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (!wself) return;
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_main_sync_safe (^{
                self.image = image;
                [self setNeedsDisplay];
                });
            }
            
        }];
    }else
    {
        
    }
    
    
}
@end
