//
//  UIScreen+WTRequestCenter.m
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/27.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "UIScreen+WTRequestCenter.h"

@implementation UIScreen (WTRequestCenter)
+(CGFloat)screenWidth
{
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}

+(CGFloat)screenHeight
{
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}

+(CGSize)screenSize
{
    return [UIScreen mainScreen].bounds.size;
}


+(CGFloat)convertWidthTo320Standard:(CGFloat)width
{
    CGFloat result = 0;
    CGFloat multiple = [self screenWidth]/320.0;
    result = width/multiple;
    return result;
}

@end
