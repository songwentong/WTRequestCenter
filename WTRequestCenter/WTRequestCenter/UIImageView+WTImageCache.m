//
//  UIImageView+WTImageCache.m
//  WTRequestCenter
//
//  Created by songwt on 14-7-30.
//  Copyright (c) 2014年 song. All rights reserved.
//

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
