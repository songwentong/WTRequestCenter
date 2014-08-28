//
//  UIImageView+WTImageCache.m
//  WTRequestCenter
//
//  Created by song on 14-7-19.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import "UIImageView+WTRequestCenter.h"
#import "WTRequestCenter.h"
@implementation UIImageView (WTRequestCenter)
- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    self.image = placeholder;
    if (url) {
        [WTRequestCenter getWithURL:url parameters:nil completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            UIImage *image = [UIImage imageWithData:data];
            self.image = image;
            [self setNeedsDisplay];
        }];
    }else
    {
        
    }
    
    
}
@end
