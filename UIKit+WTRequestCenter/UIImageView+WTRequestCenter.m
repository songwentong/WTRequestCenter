//
//  UIImageView+WTImageCache.m
//  WTRequestCenter
//
//  Created by song on 14-7-19.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter


#import <objc/runtime.h>
#import "WTNetWork.h"
@import UIKit;
@interface UIImageView()
//@property (nonatomic,strong,readwrite) WTURLRequestOperation *wtImageRequestOperation;

@end
@implementation UIImageView (WTRequestCenter)


//设置图片的Operation
//static const void * const WTImageViewOperationKey = @"WT ImageView Operation Key";

//static const void * const WTHighlightedImageOperationKey = @"WT Highlighted Image Operation Key";



- (void)setImageWithURL:(NSString *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    
    [self setImageWithURL:url placeholderImage:placeholder finished:nil failed:nil];
}

-(void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder finished:(dispatch_block_t)finished failed:(dispatch_block_t)failed
{

    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
    {
        self.image = placeholder;
    }];
    
    
    NSMutableURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    [[[WTNetWorkManager sharedKit].session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        UIImage *image = [UIImage imageWithData:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.image = image;
        }];
    }] resume];
    
}

-(void)setHighlightedImageWithURL:(NSString *)url
{
    [self setHighlightedImageWithURL:url
                    placeholderImage:nil];
}

-(void)setHighlightedImageWithURL:(NSString *)url placeholderImage:(UIImage*)placeholderImage
{
    [self setHighlightedImageWithURL:url placeholderImage:placeholderImage];
}

-(void)setHighlightedImageWithURL:(NSString *)url placeholderImage:(UIImage*)placeholderImage finished:(dispatch_block_t)finished failed:(dispatch_block_t)failed
{

    [[NSOperationQueue mainQueue] addOperationWithBlock:^
     {
         self.highlightedImage = placeholderImage;
     }];
    
    
    NSMutableURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    [[[WTNetWorkManager sharedKit].session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          UIImage *image = [UIImage imageWithData:data];
          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
              self.highlightedImage = image;
          }];
      }] resume];
}

@end
