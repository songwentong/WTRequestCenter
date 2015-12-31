//
//  UIButton+WTImageCache.m
//  WTRequestCenter
//
//  Created by songwt on 14-7-30.
//  Copyright (c) 2014年 song. All rights reserved.
//



#import "UIButton+WTRequestCenter.h"
#import "WTNetWorkManager.h"
#import <objc/runtime.h>
#import "UIImage+ImageCache.h"
@implementation UIButton (WTImageCache)

//设置图片的Operation
static const void * const WTButtonImageOperationKey = @"WT Button Image Operation Key";
//设置背景图的Operation
static const void * const WTButtonBackGroundImageOperationKey = @"WT Button Back Ground Image Operation Key";
-(NSOperation*)wtImageRequestOperation
{

    NSOperation *operation = (NSOperation*)objc_getAssociatedObject(self, WTButtonImageOperationKey);
    return operation;
}

-(void)setWtImageRequestOperation:(NSOperation *)wtImageRequestOperation
{
    objc_setAssociatedObject(self, WTButtonImageOperationKey, wtImageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSOperation*)wtBackGroundImageRequestOperation
{
    NSOperation *operation = (NSOperation*)objc_getAssociatedObject(self, WTButtonBackGroundImageOperationKey);
    return operation;
}

-(void)setWtBackGroundImageRequestOperation:(NSOperation *)wtBackGroundImageRequestOperation
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
    
    
    NSMutableURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    
    
    NSOperation *operation = [UIImage imageOperationWithURL:url complection:^(UIImage *image,NSError *error) {
        [WTNetWorkManager safeSycInMainQueue:^{
            [self setImage:image forState:state];
            [self setNeedsLayout];
        }];
    }];
    [self setWtImageRequestOperation:operation];
    [operation start];
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
    NSMutableURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    
    
    NSOperation *operation = [UIImage imageOperationWithURL:url complection:^(UIImage *image,NSError *error) {
        [WTNetWorkManager safeSycInMainQueue:^{
            [self setBackgroundImage:image forState:state];
            [self setNeedsLayout];
        }];
    }];
    
    [self setWtBackGroundImageRequestOperation:operation];
    [operation start];
             
}


@end
