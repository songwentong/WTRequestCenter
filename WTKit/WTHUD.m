//
//  ViewController.m
//  WTKit
//
//  Created by SongWentong on 18/04/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

#import "WTHUD.h"
/*
 isloading
 [self showLoading]
 [self stopLoading]
 */
#import <objc/runtime.h>
#import "WTHUDView.h"
@implementation UIViewController(HUD)
static const void * const WTHUDViewKey = @"WT hud view Key";
-(WTHUDView*)getHUDView{
    return objc_getAssociatedObject(self, WTHUDViewKey);
}
-(void)setHUDView:(WTHUDView*)hudView{
    objc_setAssociatedObject(self, WTHUDViewKey, hudView, OBJC_ASSOCIATION_ASSIGN);
}
-(void)showLoadingView{
    if ([self isKindOfClass:[UITableViewController class]]) {
        NSLog(@"please do not use hud in UITableViewController instances,use UIViewController is good!");
        return;
    }
    if ([self getHUDView] == nil) {
        WTHUDView *hud = [WTHUDView HUDForType:WTHUDViewTypeIndicatorView];
        [self.view addSubview:hud];
        hud.center = self.view.center;
        [self setHUDView:hud];
    }
    [[self getHUDView] startAnimating];
}
-(void)stopLoadingView{
    [[self getHUDView] stopAnimating];
}
@end
