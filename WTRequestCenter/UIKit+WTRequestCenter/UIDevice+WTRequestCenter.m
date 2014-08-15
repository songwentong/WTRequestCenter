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
        uuid = @"sorry, this method is not Available before 6.0";
    }
    
    return uuid;
}
@end
