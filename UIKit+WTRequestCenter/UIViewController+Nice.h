//
//  UIViewController+Nice.h
//  WTRequestCenter
//
//  Created by SongWentong on 3/2/16.
//  Copyright © 2016 song. All rights reserved.
//

#import <UIKit/UIKit.h>


//iOS 8可用的alertcontroller
@interface UIViewController (Nice)
-(void)showAlertWithMessage:(NSString*)message;
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message duration:(NSTimeInterval)time;
@end


//快速创建来自storyboard的控制器
@interface UIViewController (IBHelper)
+(instancetype)instanceFromIB;
+(instancetype)instanceFromStoryBoardName:(NSString*)storyBoardName;
+(instancetype)instanceFromStoryBoard:(UIStoryboard*)sb;
+(instancetype)instanceFromStoryBoard:(UIStoryboard*)sb name:(NSString*)name;
@end
