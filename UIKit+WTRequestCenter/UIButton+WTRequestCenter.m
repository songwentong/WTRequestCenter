//
//  UIButton+WTImageCache.m
//  WTRequestCenter
//
//  Created by songwt on 14-7-30.
//  Copyright (c) 2014年 song. All rights reserved.
//



#import "UIButton+WTRequestCenter.h"
#import "WTRequestCenter.h"
#import "UIKit+WTRequestCenter.h"
#import <objc/runtime.h>
#import "WTURLRequestOperation.h"

@implementation UIButton (WTImageCache)

//设置图片的Operation
static const void * const WTButtonImageOperationKey = @"WT Button Image Operation Key";
//设置背景图的Operation
static const void * const WTButtonBackGroundImageOperationKey = @"WT Button Back Ground Image Operation Key";
-(WTURLRequestOperation*)wtImageRequestOperation
{

    WTURLRequestOperation *operation = (WTURLRequestOperation*)objc_getAssociatedObject(self, WTButtonImageOperationKey);
    return operation;
}

-(void)setWtImageRequestOperation:(WTURLRequestOperation *)wtImageRequestOperation
{
    objc_setAssociatedObject(self, WTButtonImageOperationKey, wtImageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(WTURLRequestOperation*)wtBackGroundImageRequestOperation
{
    WTURLRequestOperation *operation = (WTURLRequestOperation*)objc_getAssociatedObject(self, WTButtonBackGroundImageOperationKey);
    return operation;
}

-(void)setWtBackGroundImageRequestOperation:(WTURLRequestOperation *)wtBackGroundImageRequestOperation
{
    objc_setAssociatedObject(self, WTButtonBackGroundImageOperationKey, wtBackGroundImageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [strongSelf setImage:image forState:state];
                    [strongSelf setNeedsLayout];
                }];
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
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [strongSelf setBackgroundImage:image forState:state];
                        [strongSelf setNeedsLayout];
                    }];
                    
                }
            }

        }];

    } failed:^(NSURLResponse *response, NSError *error) {
        
    }];
             
}


@end
