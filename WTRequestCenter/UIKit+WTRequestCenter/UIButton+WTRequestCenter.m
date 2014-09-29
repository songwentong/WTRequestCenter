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
                 withURL:(NSString *)url
{
    [self setImageForState:state withURL:url placeholderImage:nil];
}
- (void)setImageForState:(UIControlState)state
                 withURL:(NSString *)url
        placeholderImage:(UIImage *)placeholderImage
{
    [self setImage:placeholderImage forState:state];
    if (!url) {
        return;
    }
    __weak UIButton *weakSelf = self;
    
    
    [WTRequestCenter getCacheWithURL:url parameters:nil finished:^(NSURLResponse *response, NSData *data) {
        [[WTRequestCenter sharedQueue] addOperationWithBlock:^{
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                if (weakSelf) {
                    __strong UIButton *strongSelf = weakSelf;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf setImage:image forState:state];
                        [strongSelf setNeedsLayout];
                    });
                }
            }
        }];

    } failed:^(NSURLResponse *response, NSError *error) {
        
    }];

}

- (void)setBackgroundImage:(UIControlState)state
                   withURL:(NSString *)url
{
    [self setBackgroundImage:state withURL:url placeholderImage:nil];
}

- (void)setBackgroundImage:(UIControlState)state
                 withURL:(NSString *)url
        placeholderImage:(UIImage *)placeholderImage
{
    [self setBackgroundImage:placeholderImage forState:state];
    
    if (!url) {
        return;
    }
    __weak UIButton *weakSelf = self;
    
    
    [WTRequestCenter getCacheWithURL:url parameters:nil finished:^(NSURLResponse *response, NSData *data) {
        if (data) {
            [[WTRequestCenter sharedQueue] addOperationWithBlock:^{
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    
                    if (weakSelf) {
                        __strong UIButton *strongSelf = weakSelf;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [strongSelf setBackgroundImage:image forState:state];
                            [strongSelf setNeedsLayout];
                        });
                    }
                }
            }];
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        
    }];
}


@end
