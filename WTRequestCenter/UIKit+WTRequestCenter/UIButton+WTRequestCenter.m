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
#import "UIKit+WTRequestCenter.h"
#import <objc/runtime.h>
@implementation UIButton (WTImageCache)

-(WTURLRequestOperation*)wtImageRequestOperation
{
    WTURLRequestOperation *operation = (WTURLRequestOperation*)objc_getAssociatedObject(self, @"a");
    return operation;
}

-(void)setWtImageRequestOperation:(WTURLRequestOperation *)wtImageRequestOperation
{
    objc_setAssociatedObject(self, @"a", wtImageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(WTURLRequestOperation*)wtBackGroundImageRequestOperation
{
    WTURLRequestOperation *operation = (WTURLRequestOperation*)objc_getAssociatedObject(self, @"b");
    return operation;
}

-(void)setWtBackGroundImageRequestOperation:(WTURLRequestOperation *)wtBackGroundImageRequestOperation
{
    objc_setAssociatedObject(self, @"b", wtBackGroundImageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



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
    
    if (self.wtImageRequestOperation) {
        [self.wtImageRequestOperation cancel];
        self.wtImageRequestOperation = nil;
    }
    
    if (!url) {
        return;
    }
    __weak UIButton *weakSelf = self;
    

    WTURLRequestOperation *operation = [WTRequestCenter testGetWithURL:url parameters:nil option:WTRequestCenterCachePolicyCacheElseWeb finished:^(NSURLResponse *response, NSData *data) {
        
        [UIImage imageWithData:data complectionHandler:^(UIImage *image) {
            
            if (image) {
                if (!weakSelf) return;
                __strong UIButton *strongSelf = weakSelf;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    strongSelf.image = image;
                    [strongSelf setImage:image forState:state];
                    [strongSelf setNeedsDisplay];
                    
                });
                strongSelf.wtImageRequestOperation = nil;
            }
        }];
        [[WTRequestCenter sharedQueue] addOperationWithBlock:^{
//            UIImage *image = [UIImage imageWithData:data];
            
        }];
        
    } failed:^(NSURLResponse *response, NSError *error) {

//        if (!weakSelf) return;
//        __strong UIImageView *strongSelf = weakSelf;
//        strongSelf.wtImageRequestOperation = nil;
    }];
    
    self.wtImageRequestOperation = operation;

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
    
    if (self.wtBackGroundImageRequestOperation) {
        [self.wtBackGroundImageRequestOperation cancel];
        self.wtBackGroundImageRequestOperation = nil;
    }
    [self setBackgroundImage:placeholderImage forState:state];
    
    if (!url) {
        return;
    }
    __weak UIButton *weakSelf = self;
    
    self.wtBackGroundImageRequestOperation = [WTRequestCenter testGetWithURL:url parameters:nil option:WTRequestCenterCachePolicyCacheElseWeb finished:^(NSURLResponse *response, NSData *data) {
        
        
        [UIImage imageWithData:data complectionHandler:^(UIImage *image) {
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

    } failed:^(NSURLResponse *response, NSError *error) {
        
    }];
             
}


@end
