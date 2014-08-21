//
//  UIButton+WTImageCache.m
//  WTRequestCenter
//
//  Created by songwt on 14-7-30.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "UIButton+WTRequestCenter.h"
#import "WTRequestCenter.h"
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
    [WTRequestCenter getImageWithURL:url completionHandler:^(UIImage *image) {
        [self setImage:image forState:state];
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
    [WTRequestCenter getImageWithURL:url completionHandler:^(UIImage *image) {
        [self setBackgroundImage:image forState:state];
    }];
}


@end
