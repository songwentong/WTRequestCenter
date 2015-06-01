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
        
        
        WTURLRequestOperation *operation = nil;
        
        operation = [[WTRequestCenter requestCenter] GET:url
                                              parameters:nil
                                             shouldCache:YES
                                                finished:^(WTURLRequestOperation *operation, NSData *data)
        {
            [UIImage imageWithData:data complectionHandler:^(UIImage *image) {
                
                if (image) {
                    if (!wself) return;
                    __strong UIImageView *strongSelf = wself;
                    dispatch_block_t block = ^{
                        strongSelf.image = image;
                        [strongSelf setNeedsLayout];
                    };
                    [[NSOperationQueue mainQueue] addOperationWithBlock:block];
                    
                }
                
                
            }];
            
            
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (finished) {
                    finished(operation.response,operation.responseData);
                }
            }];

        } failed:^(WTURLRequestOperation *operation, NSError *error)
        {
        
        }];
        
        
        self.wtImageRequestOperation = operation;
    }else
    {
        
    }
}




@end
