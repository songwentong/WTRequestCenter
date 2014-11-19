//
//  UIDevice+WTRequestCenter.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-12.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter
//  install
//  git clone https://github.com/swtlovewtt/WTRequestCenter
#import <UIKit/UIKit.h>

@interface UIDevice (WTRequestCenter)


//UUID  唯一标示符
+(NSString*)WTUUID;

//屏幕宽度
+(CGFloat)screenWidth;

//屏幕高度
+(CGFloat)screenHeight;

//屏幕大小
+(CGSize)screenSize;
@end
