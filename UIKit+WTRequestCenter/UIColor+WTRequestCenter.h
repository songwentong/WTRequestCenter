//
//  UIColor+FastCreating.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-14.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WTRequestCenter)

/*!
    RGB一样的情况下，生成的颜色
 */
+ (UIColor*)WTcolorWithFloat:(CGFloat)number;

/*!
    根据RGB生成颜色，颜色为0-255
 */
+ (UIColor *)WTcolorWithRed:(CGFloat)red
                      green:(CGFloat)green
                       blue:(CGFloat)blue;

/*!
    根据RGBA生成颜色，颜色为0-255
 */
+ (UIColor *)WTcolorWithRed:(CGFloat)red
                      green:(CGFloat)green
                       blue:(CGFloat)blue
                      alpha:(CGFloat)alpha;

/*!
    调用 WTcolorWithHexString： alpha方法，alpha为1
 */
+ (UIColor *)WTcolorWithHexString:(NSString *)str;

/*!
    根据hex字符串和alpha创建颜色
    长度为1，2，3，6，7都可以解析
    长度为1，会复制成6个字符来读取颜色
    长度为2，会复制成三份一样的颜色来读取
    长度为3，比如abc  会变成aabbcc
    长度为6，标准读取
    长度为7，去掉前面的井号读取
 */
+ (UIColor *)WTcolorWithHexString:(NSString *)hexString
                            alpha:(CGFloat)alpha;

/*!
    随机得到一个颜色
 */
+(UIColor*)WTRandomColor;


/*!
    取反色
 */
+(UIColor*)WTAntiColor:(UIColor*)color withStride:(CGFloat)stride;

/*!
 取反色
 */
-(UIColor*)WTAntiColorWithStride:(CGFloat)stride;
@end
