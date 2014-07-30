//
//  UIImageView+WTImageCache.m
//  WTRequestCenter
//
//  Created by song on 14-7-19.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import "UIImageView+WTImageCache.h"
#import "WTRequestCenter.h"
@implementation UIImageView (WTImageCache)
- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    self.image = placeholder;
    [WTRequestCenter getImageWithURL:url completionHandler:^(UIImage *image) {
        self.image = image;
    }];
}
@end
