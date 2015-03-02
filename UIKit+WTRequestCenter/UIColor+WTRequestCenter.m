//
//  UIColor+FastCreating.m
//  WTRequestCenter
//
//  Created by songwt on 14-8-14.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "UIColor+WTRequestCenter.h"

@implementation UIColor (WTRequestCenter)

+(UIColor*)WTAntiColor:(UIColor*)color withStride:(CGFloat)stride
{

    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    r = [self WTAntiValueWithValue:r stride:stride];
    g = [self WTAntiValueWithValue:g stride:stride];
    b = [self WTAntiValueWithValue:b stride:stride];
    UIColor *result = [UIColor colorWithRed:r green:g blue:b alpha:a];
    return result;
}

-(UIColor*)WTAntiColorWithStride:(CGFloat)stride
{
    return [UIColor WTAntiColor:self withStride:stride];
}

+(CGFloat)WTAntiValueWithValue:(CGFloat)value stride:(CGFloat)stride
{
    CGFloat result = 0;
    if (value>0.5) {
        result = value+stride;
    }else
    {
        result = value-stride;
    }
    
    return result;
}

+ (UIColor*)WTcolorWithFloat:(CGFloat)number
{
    return [self WTcolorWithRed:number
                          green:number
                           blue:number];
}

+ (UIColor *)WTcolorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    return [self WTcolorWithRed:red
                          green:green
                           blue:blue
                          alpha:1.0];
}

+ (UIColor *)WTcolorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    UIColor *color = nil;
    color = [UIColor colorWithRed:red/255.000
                            green:green/255.000
                             blue:blue/255.000
                            alpha:alpha];
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
    return [self WTcolorWithHexString:str
                                alpha:1.0];
}

+ (UIColor *)WTcolorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    // #rgb = #rrggbb
    
    NSString *tempString = @"";
    
    if ([hexString hasPrefix:@"#"]) {
        tempString = [hexString substringFromIndex:1];
    }
    
    if ([hexString length]==1) {
        tempString = [NSString stringWithFormat:@"%@%@%@%@%@%@",hexString,hexString,hexString,hexString,hexString,hexString];
    }
    
    if ([hexString length]==2) {
        tempString = [NSString stringWithFormat:@"%@%@%@",hexString,hexString,hexString];
    }
    
    if ([hexString length] == 3) {
        NSString *oneR = [hexString substringWithRange:NSMakeRange(0, 1)];
        NSString *oneG = [hexString substringWithRange:NSMakeRange(1, 1)];
        NSString *oneB = [hexString substringWithRange:NSMakeRange(2, 1)];
        
        tempString = [NSString stringWithFormat:@"%@%@%@%@%@%@", oneR, oneR, oneG, oneG, oneB, oneB];
    }
    
    if ([hexString length]==6) {
        tempString = hexString;
    }
    
    if ([tempString length]!=6) {
        return nil;
    }
    
    CGFloat red = [self integerValueFromHexString:[tempString substringWithRange:NSMakeRange(0, 2)]];
    
    CGFloat green = [self integerValueFromHexString:[tempString substringWithRange:NSMakeRange(2, 2)]];
    
    CGFloat blue = [self integerValueFromHexString:[tempString substringWithRange:NSMakeRange(4, 2)]];
    
    return [self WTcolorWithRed:red
                          green:green
                           blue:blue
                          alpha:alpha];
}

+(uint8_t)randomColorValue
{
    uint8_t color;
    SecRandomCopyBytes(kSecRandomDefault, 1, &color);
    color = color%256;
    return color;
}

+(UIColor*)WTRandomColor
{
    uint8_t red = [self randomColorValue];
    uint8_t green = [self randomColorValue];
    uint8_t blue = [self randomColorValue];

    return [self WTcolorWithRed:red
                          green:green
                           blue:blue];
}

@end
