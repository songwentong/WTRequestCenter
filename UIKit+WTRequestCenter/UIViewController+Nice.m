//
//  UIViewController+Nice.m
//  WTRequestCenter
//
//  Created by SongWentong on 3/2/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "UIViewController+Nice.h"
#import "WTNetWorkManager.h"
@implementation UIViewController (Nice)
-(void)showAlertWithMessage:(NSString*)message
{
    [self showAlertWithTitle:nil message:message duration:1.0];
}
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message duration:(NSTimeInterval)time
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [WTNetWorkManager performBlock:^{
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    } afterDelay:time];
    
    
}
@end
