//
//  UIDevice+WTRequestCenter.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-12.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter
//  install
//  git clone https://github.com/swtlovewtt/WTRequestCenter


#if TARGET_OS_IOS
@import UIKit;

@interface UIDevice (WTRequestCenter)


//UUID  唯一标示符
/*!
 唯一标示符
 注意：如果程序被删除了，然后在安装，这个数值会改变。
      如果想要永久保证这个数字不变，需要使用Keychain来保存这个字符串
 */
+(NSString*)WTUUID;



/**
 取得屏幕大小

 @return 得到屏幕尺寸,模拟器没有
 */
+(CGFloat)getScreenSize;
/*!
 系统版本
 */
+(CGFloat)systemVersion;

/*!
 设备类型
 */
+(NSString *)getDeviceType;
@end
#endif
