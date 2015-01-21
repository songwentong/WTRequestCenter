//
//  UIViewController+WTRequestCenter.h
//  WTRequestCenter
//
//  Created by SongWentong on 15/1/21.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTNetworkHUD;
@interface UIViewController (WTRequestCenter)

//初始化
-(void)initHUD;

-(WTNetworkHUD*)wtActiveIndicatorView;

//显示HUD
-(void)startLoadWTHud;
//隐藏HUD
-(void)stopLoadWTHud;

@end
