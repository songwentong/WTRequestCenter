//
//  UIButton+WTImageCache.m
//  WTRequestCenter
//
//  Created by songwt on 14-7-30.
//  Copyright (c) 2014年 song. All rights reserved.
//



#import "UIButton+WTRequestCenter.h"
#import "WTRequestCenter.h"
#import "WTRequestCenterMacro.h"


@implementation UIButton (WTImageCache)

- (void)setImageForState:(UIControlState)state
                 withURL:(NSURL *)url
{
    [self setImageForState:state withURL:url placeholderImage:nil];
}
- (void)setImageForState:(UIControlState)state
                 withURL:(NSURL *)url
        placeholderImage:(UIImage *)placeholderImage
{
    [self setImage:placeholderImage forState:state];
    if (!url) {
        return;
    }
    __weak UIButton *weakSelf = self;
    [WTRequestCenter getWithURL:url parameters:nil completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        dispatch_main_sync_safe(^{
            if (image) {
                if (weakSelf) {
                    [weakSelf setImage:image forState:state];
                    [weakSelf setNeedsLayout];
                }
            }
        });
    }];

}

- (void)setBackgroundImage:(UIControlState)state
                   withURL:(NSURL *)url
{
    [self setBackgroundImage:state withURL:url placeholderImage:nil];
}

- (void)setBackgroundImage:(UIControlState)state
                 withURL:(NSURL *)url
        placeholderImage:(UIImage *)placeholderImage
{
    [self setBackgroundImage:placeholderImage forState:state];
    
    if (!url) {
        return;
    }
    __weak UIButton *weakSelf = self;
    [WTRequestCenter getWithURL:url parameters:nil completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            dispatch_main_sync_safe(^{
            if (weakSelf) {
                [weakSelf setBackgroundImage:image forState:state];
                [weakSelf setNeedsLayout];
            }
            });
        }
    }];
}


@end
