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

+(CGFloat)systemVersion
{
    CGFloat version = 0;
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    UIDevice *currentDevice = [UIDevice currentDevice];
    version = currentDevice.systemVersion.floatValue;
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    NSDictionary * sv = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"];
    version = [[sv objectForKey:@"ProductVersion"] floatValue];
#endif
    
    return version;
}
@end
