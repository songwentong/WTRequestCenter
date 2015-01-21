//
//  UIViewController+WTRequestCenter.m
//  WTRequestCenter
//
//  Created by SongWentong on 15/1/21.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "UIViewController+WTRequestCenter.h"
#import <objc/runtime.h>
//准备做一个加载的指示器
@implementation UIViewController (WTRequestCenter)


//设置图片的Operation
static const void * const WTImageViewOperationKey = @"WT UIActivity Indicator View";

-(UIActivityIndicatorView*)wtActiveIndicatorView
{
    UIActivityIndicatorView *active = (UIActivityIndicatorView*)objc_getAssociatedObject(self, WTImageViewOperationKey);
    return active;
}
-(void)setwtActiveIndicatorView:(UIActivityIndicatorView*)view
{
    objc_setAssociatedObject(self, WTImageViewOperationKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)startLoadWTHud
{
    if (![self wtActiveIndicatorView]) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = self.view.frame;
        indicator.hidesWhenStopped = YES;
        indicator.center = self.view.center;
        [self.view addSubview:indicator];
        [self setwtActiveIndicatorView:indicator];
    }
    [[self wtActiveIndicatorView] startAnimating];
}

-(void)stopLoadWTHud
{
    [[self wtActiveIndicatorView] stopAnimating];
    
}

@end
