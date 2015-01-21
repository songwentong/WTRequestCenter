//
//  UIImageView+WTImageCache.m
//  WTRequestCenter
//
//  Created by song on 14-7-19.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import "UIImageView+WTRequestCenter.h"
#import <objc/runtime.h>
#import "UIImage+WTRequestCenter.h"
#import "WTURLRequestOperation.h"

@interface UIImageView()
//@property (nonatomic,strong,readwrite) WTURLRequestOperation *wtImageRequestOperation;

@end
@implementation UIImageView (WTRequestCenter)


//设置图片的Operation
static const void * const WTImageViewOperationKey = @"WT ImageView Operation Key";

-(WTURLRequestOperation*)wtImageRequestOperation
{
    WTURLRequestOperation *operation = (WTURLRequestOperation*)objc_getAssociatedObject(self, WTImageViewOperationKey);
    return operation;
}

-(void)setWtImageRequestOperation:(WTURLRequestOperation *)wtImageRequestOperation
{
    objc_setAssociatedObject(self, WTImageViewOperationKey, wtImageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (void)setImageWithURL:(NSString *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    
    [self setImageWithURL:url placeholderImage:placeholder finished:nil failed:nil];
}

-(void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder finished:(WTRequestFinishedBlock)finished failed:(WTRequestFailedBlock)failed
{
    if (self.wtImageRequestOperation) {
        [self.wtImageRequestOperation cancel];
        self.wtImageRequestOperation = nil;
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
    {
        self.image = placeholder;
    }];

    if (url) {
        __weak UIImageView *wself    = self;
        
        
        WTURLRequestOperation *operation = [WTRequestCenter testGetWithURL:url parameters:nil option:WTRequestCenterCachePolicyCacheElseWeb finished:^(NSURLResponse *response, NSData *data) {
            
            [UIImage imageWithData:data complectionHandler:^(UIImage *image) {
                
                if (image) {
                    if (!wself) return;
                    __strong UIImageView *strongSelf = wself;
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        strongSelf.image = image;
                        [strongSelf setNeedsLayout];
                    }];
                    strongSelf.wtImageRequestOperation = nil;
                }
                
                
            }];
            
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (finished) {
                    finished(response,data);
                    }
                }];
            
            
        } failed:^(NSURLResponse *response, NSError *error) {
            if (!wself) return;
            __strong UIImageView *strongSelf = wself;
            if (failed) {
                failed(self.wtImageRequestOperation.response,self.wtImageRequestOperation.error);
            }
            strongSelf.wtImageRequestOperation = nil;
        }];
        
        self.wtImageRequestOperation = operation;
    }else
    {
        
    }
}




@end
