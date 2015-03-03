//
//  UIAlertView+WTRequestCenter.h
//  WTRequestCenter
//
//  Created by SongWentong on 14-10-16.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (WTRequestCenter)
+(void)showAlertWithMessage:(NSString*)message;

+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message duration:(NSTimeInterval)time;
//显示一个提示框
+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message duration:(NSTimeInterval)time complectionHandler:(dispatch_block_t)block;
@end
