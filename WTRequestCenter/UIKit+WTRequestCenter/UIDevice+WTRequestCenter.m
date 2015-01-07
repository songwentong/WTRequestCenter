//
//  UIDevice+WTRequestCenter.m
//  WTRequestCenter
//
//  Created by song on 14-8-15.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "UIDevice+WTRequestCenter.h"
#import <sys/sysctl.h>
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
    UIDevice *currentDevice = [UIDevice currentDevice];
    version = currentDevice.systemVersion.floatValue;
    return version;
}



+(NSString *)getDeviceType
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])
        platform = @"iPhone";
    else if ([platform isEqualToString:@"iPhone1,2"])
        platform = @"iPhone 3G";
    else if ([platform isEqualToString:@"iPhone2,1"])
        platform = @"iPhone 3GS";
    else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"])
        platform = @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone4,1"])
        platform = @"iPhone 4S";
    else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"])
        platform = @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"])
        platform = @"iPhone 5C";
    else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"])
        platform = @"iPhone 5S";
    else if ([platform isEqualToString:@"iPod4,1"])
        platform = @"iPod touch 4";
    else if ([platform isEqualToString:@"iPod5,1"])
        platform = @"iPod touch 5";
    else if ([platform isEqualToString:@"iPod3,1"])
        platform = @"iPod touch 3";
    else if ([platform isEqualToString:@"iPod2,1"])
        platform = @"iPod touch 2";
    else if ([platform isEqualToString:@"iPod1,1"])
        platform = @"iPod touch";
    else if ([platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,1"]||[platform isEqualToString:@"iPad3,3"])
        platform = @"iPad 3";
    else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"])
        platform = @"iPad 2";
    else if ([platform isEqualToString:@"iPad1,1"])
        platform = @"iPad 1";
    else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"])
        platform = @"ipad mini";
    else if ([platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"])
        platform = @"ipad 4";
    return platform;
}
@end
