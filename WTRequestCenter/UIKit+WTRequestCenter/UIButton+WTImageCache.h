//
//  UIButton+WTImageCache.h
//  WTRequestCenter
//
//  Created by songwt on 14-7-30.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WTImageCache)

- (void)setImageForState:(UIControlState)state
                 withURL:(NSURL *)url;

- (void)setImageForState:(UIControlState)state
                 withURL:(NSURL *)url
        placeholderImage:(UIImage *)placeholderImage;

- (void)setBackgroundImage:(UIControlState)state
                   withURL:(NSURL *)url;

- (void)setBackgroundImage:(UIControlState)state
                   withURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholderImage;
@end
