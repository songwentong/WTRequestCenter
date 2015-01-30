//
//  UIViewController+WTRequestCenter.m
//  WTRequestCenter
//
//  Created by SongWentong on 15/1/21.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "UIViewController+WTRequestCenter.h"
#import <objc/runtime.h>
#import "WTNetworkHUD.h"

//准备做一个加载的指示器
@implementation UIViewController (WTRequestCenter)


//设置图片的Operation
static const void * const WTImageViewOperationKey = @"WT UIActivity Indicator View";

-(WTNetworkHUD*)wtActiveIndicatorView
{
    WTNetworkHUD *active = (WTNetworkHUD*)objc_getAssociatedObject(self, WTImageViewOperationKey);
    return active;
}
-(void)setwtActiveIndicatorView:(WTNetworkHUD*)view
{
    objc_setAssociatedObject(self, WTImageViewOperationKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)initHUD
{
    if (![self wtActiveIndicatorView]) {
        WTNetworkHUD *indicator = [[WTNetworkHUD alloc] init];
        indicator.frame = self.view.frame;
        indicator.center = self.view.center;
        [self.view addSubview:indicator];
        [self setwtActiveIndicatorView:indicator];
    }
}

-(void)startLoadWTHud
{
    if (![self wtActiveIndicatorView]) {
        [self initHUD];
    }
    [[self wtActiveIndicatorView] startAnimating];
}

-(void)stopLoadWTHud
{
    [[self wtActiveIndicatorView] stopAnimating];
    
}


/**
 *  摇晃动画
 */
-(void)wtAnimationShake
{
    
}

@end
