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


+ (NSUInteger)integerValueFromHexString:(NSString *)hexString {
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    unsigned int result;
    [scanner scanHexInt:&result];
    return result;
}

+ (UIColor *)WTcolorWithHexString:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

+ (UIColor *)WTcolorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    // #rgb = #rrggbb
    
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    
    if ([hexString length] == 3) {
        NSString *oneR = [hexString substringWithRange:NSMakeRange(0, 1)];
        NSString *oneG = [hexString substringWithRange:NSMakeRange(1, 1)];
        NSString *oneB = [hexString substringWithRange:NSMakeRange(2, 1)];
        
        hexString = [NSString stringWithFormat:@"%@%@%@%@%@%@", oneR, oneR, oneG, oneG, oneB, oneB];
    }
    
    if ([hexString length]!=6) {
        return nil;
    }
    
    CGFloat red = [self integerValueFromHexString:[hexString substringWithRange:NSMakeRange(0, 2)]];
    CGFloat green = [self integerValueFromHexString:[hexString substringWithRange:NSMakeRange(2, 2)]];
    CGFloat blue = [self integerValueFromHexString:[hexString substringWithRange:NSMakeRange(4, 2)]];
    
    return [self colorWithRed:red green:green blue:blue alpha:alpha];
}



@end
