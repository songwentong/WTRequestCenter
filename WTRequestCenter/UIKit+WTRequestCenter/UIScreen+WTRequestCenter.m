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


+(CGFloat)convert320ToCurrentWidth:(CGFloat)width
{
    CGFloat result = 0;
    CGFloat multiple = [self screenWidth]/320.0;
    result = width * multiple;
    return result;
}

+(CGPoint)convert320ToCurrentPoint:(CGPoint)point
{
    CGPoint result;
    CGFloat multiple = [self screenWidth]/320.0;
    result = CGPointMake(point.x*multiple, point.y*multiple);
    
    return result;
}


+(CGRect)convert320ToCurrentRect:(CGRect)rect
{
    CGRect result;
    CGFloat multiple = [self screenWidth]/320.0;
    result = CGRectMake(rect.origin.x*multiple, rect.origin.y*multiple, rect.size.width*multiple, rect.size.height*multiple);
    
    return result;
}
@end
