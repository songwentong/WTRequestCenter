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
        
#if ( ( defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090) || \
( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < 70000 ) )
        uuid = [device uniqueIdentifier];
        #endif
    }
    
    return uuid;
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
