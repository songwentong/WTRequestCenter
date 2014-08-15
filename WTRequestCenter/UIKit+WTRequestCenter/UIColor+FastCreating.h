//
//  UIColor+FastCreating.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-14.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FastCreating)

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
@end
