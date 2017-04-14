//
//  UIApplication+Nice.h
//  WTRequestCenter
//
//  Created by SongWentong on 3/22/16.
//  Copyright © 2016 song. All rights reserved.
//
#if TARGET_OS_IOS
@import UIKit;

@interface UIApplication (Nice)
//获得程序的根控制器
+(UIViewController*)rootViewController;
@end
#endif
