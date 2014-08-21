//
//  UIColor+FastCreating.m
//  WTRequestCenter
//
//  Created by songwt on 14-8-14.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "UIColor+WTRequestCenter.h"

@implementation UIColor (WTRequestCenter)

+ (UIColor*)WTcolorWithFloat:(CGFloat)number
{
    return [self WTcolorWithRed:number green:number blue:number];
}

+ (UIColor *)WTcolorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    return [self WTcolorWithRed:red green:green blue:blue alpha:1.0];
}
+ (UIColor *)WTcolorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    UIColor *color = nil;
    color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
    return color;
}
@end
