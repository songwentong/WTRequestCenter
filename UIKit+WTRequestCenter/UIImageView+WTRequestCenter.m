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

@end
@implementation UIImageView (WTRequestCenter)
static const void * const WTImageViewOperationKey = @"WT ImageView Operation Key";

static const void * const WTHighlightedImageOperationKey = @"WT Highlighted Image Operation Key";


-(void)setImageOperation:(NSOperation*)operation
{
    NSOperation *old = [self imageOperation];
    if (old) {
        if ([old isExecuting]) {
            [old cancel];
        }
    }
    
    objc_setAssociatedObject(self, WTImageViewOperationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSOperation*)imageOperation{
    return objc_getAssociatedObject(self, WTImageViewOperationKey);
}




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
    
    
    
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [[[WTNetWorkManager sharedKit].session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
          {
              if (error) {
                  if (failed) {
                      failed();
                  }
              }else{
                  UIImage *image = [UIImage imageWithData:data];
                  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                      self.image = image;
                      if (finished) {
                          finished();
                      }
                  }];
              }
              
              
              
          }] resume];
    }];
    
    [self setImageOperation:operation];
    [operation start];
    
}



@end

@implementation UIImageView(highlightedImage)

-(void)setHighlightedImageOperation:(NSOperation*)operation
{
    NSOperation *old = [self highlightedImageOperation];
    if (old) {
        if ([old isExecuting]) {
            [old cancel];
        }
    }
    
    objc_setAssociatedObject(self, WTHighlightedImageOperationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSOperation*)highlightedImageOperation{
    return objc_getAssociatedObject(self, WTHighlightedImageOperationKey);
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