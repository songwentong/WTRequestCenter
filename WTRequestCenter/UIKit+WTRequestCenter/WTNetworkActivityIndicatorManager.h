//
//  WTNetworkActivityIndicatorManager.h
//  WTRequestCenter
//
//  Created by song on 14/10/24.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTNetworkActivityIndicatorManager : NSObject


@property (nonatomic, assign, getter = isEnabled) BOOL enabled;


@property (readonly, nonatomic, assign) BOOL isNetworkActivityIndicatorVisible;

+ (instancetype)sharedManager;
- (void)incrementActivityCount;
- (void)decrementActivityCount;
@end
