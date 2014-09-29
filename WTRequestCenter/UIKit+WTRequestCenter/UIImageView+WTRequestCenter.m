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
- (void)setImageWithURL:(NSString *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    
    [self setImageWithURL:url placeholderImage:placeholder finished:nil];
}

-(void)setImageWithURL:(NSString*)url placeholderImage:(UIImage *)placeholder finished:(void (^)(NSURLResponse* response,NSData *data,UIImage *image))finished
{
    self.image = placeholder;
    if (url) {
        __weak UIImageView *wself    = self;
        
        
        [WTRequestCenter getCacheWithURL:url parameters:nil finished:^(NSURLResponse *response, NSData *data) {
            
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
        } failed:^(NSURLResponse *response, NSError *error) {
            
        }];
    }else
    {
        
    }
}



@end
