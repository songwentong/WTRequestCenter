//
//  WTNetworkActivityIndicatorManager.h
//  WTRequestCenter
//
//  Created by song on 14/10/24.
//  Copyright (c) 2014年 song. All rights reserved.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//  网络访问指示器，enable设置为YES后网络访问在状态栏有提示
@interface WTNetworkActivityIndicatorManager : NSObject

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

@property (readonly, nonatomic, assign) BOOL isNetworkActivityIndicatorVisible;

+ (instancetype)sharedManager;


- (void)incrementActivityCount;

- (void)decrementActivityCount;
@end
