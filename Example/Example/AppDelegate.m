//
//  AppDelegate.m
//  WTRequestCenter
//
//  Created by song on 14-7-19.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "AppDelegate.h"
#import "WeatherModel.h"
//@import WTKit;
@import WTKit;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    WeatherModel *w = [WeatherModel new];
    
//    [w travelData:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"JSONData" ofType:nil]] options:0 error:nil]];
//    NSLog(@"%@",w);
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"JSONData" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //    [dict printModel];
    //    [dict printModelCopy];
    WeatherModel *w = [WeatherModel new];
    [w travelData:dict];
//    NSLog(@"%@",w.attemptConvertToJSON);
    CGFloat a = 34.6f - 34.0f;
    WTLog(@"%f",a);
    
    /*
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setValue:@NO forKey:UIApplicationOpenURLOptionUniversalLinksOnly];
    [application openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:options completionHandler:^(BOOL success) {
        
    }];
     */
    WTLog(@"hello");
    /*
     isMemberOfClass 和 isKindOfClass 都针对实例就好了,对类用这种方法就是装逼用的
    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];//yes
    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];//no
    BOOL res3 = [(id)[self class] isKindOfClass:[AppDelegate class]];//no
    BOOL res4 = [(id)[self class] isMemberOfClass:[AppDelegate class]];//no
    BOOL res5 = [(id)[self class] isKindOfClass:[NSObject class]];//yes
    BOOL res6 = [(id)[self class] isMemberOfClass:[NSObject class]];//no
    */
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
