//
//  UIApplication+WTRequestCenter.m
//  WTRequestCenter
//
//  Created by SongWentong on 14/12/11.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "UIApplication+WTRequestCenter.h"

@implementation UIApplication (WTRequestCenter)






//版本号
+(NSString*)WTAppVersion
{
    NSString *version = [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleInfoDictionaryVersionKey];
    return version;
}

//build 号
+(NSString*)WTAppBuild
{
    NSString *build = [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleVersionKey];
    return build;
}
@end
