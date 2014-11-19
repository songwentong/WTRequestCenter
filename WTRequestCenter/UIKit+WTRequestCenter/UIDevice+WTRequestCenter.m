//
//  UIDevice+WTRequestCenter.m
//  WTRequestCenter
//
//  Created by song on 14-8-15.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "UIDevice+WTRequestCenter.h"

@implementation UIDevice (WTRequestCenter)

+(NSString*)WTUUID
{
    NSString *uuid = @"";
    UIDevice *device = [UIDevice currentDevice];
    
    
    if ([device.systemVersion floatValue]>=6.0) {
        NSUUID *uid = device.identifierForVendor;
        uuid = [uid UUIDString];
    }else
    {
        
//        SEL selector = @selector(uniqueIdentifier);
//        uuid = [device performSelector:selector];

    }
    
    return uuid;
}

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
@end
