//
//  UIViewController+Nice.h
//  WTRequestCenter
//
//  Created by SongWentong on 3/2/16.
//  Copyright © 2016 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Nice)
-(void)showAlertWithMessage:(NSString*)message;
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message duration:(NSTimeInterval)time;
@end
