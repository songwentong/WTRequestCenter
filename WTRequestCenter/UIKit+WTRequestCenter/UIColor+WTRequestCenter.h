//
//  UIColor+FastCreating.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-14.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WTRequestCenter)

//用色值创建颜色 RGB都是number
+ (UIColor*)WTcolorWithFloat:(CGFloat)number;

//用RGB创建颜色，分别设置RGB，无需除以255
+ (UIColor *)WTcolorWithRed:(CGFloat)red
                      green:(CGFloat)green
                       blue:(CGFloat)blue;

//用RGBA创建颜色，无需除以255.0
+ (UIColor *)WTcolorWithRed:(CGFloat)red
                      green:(CGFloat)green
                       blue:(CGFloat)blue
                      alpha:(CGFloat)alpha;

/*!
 根据hex字符串和alpha创建颜色
 长度为1，2，3，6，7都可以解析
 长度为1，会复制成6个字符来读取颜色
 长度为2，会复制成三份一样的颜色来读取
 长度为6，标准读取
 长度为7，去掉前面的井号读取
 */
+ (UIColor *)WTcolorWithHexString:(NSString *)str;

/*!
    根据hex字符串和alpha创建颜色
    长度为1，2，3，6，7都可以解析
    长度为1，会复制成6个字符来读取颜色
    长度为2，会复制成三份一样的颜色来读取
    长度为6，标准读取
    长度为7，去掉前面的井号读取
 */
+ (UIColor *)WTcolorWithHexString:(NSString *)hexString
                            alpha:(CGFloat)alpha;

@end
