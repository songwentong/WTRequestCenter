//
//  UIViewController+Nice.h
//  WTRequestCenter
//
//  Created by SongWentong on 3/2/16.
//  Copyright © 2016 song. All rights reserved.
//

#import <UIKit/UIKit.h>


//iOS 8可用的alertcontroller
@interface UIViewController (Alert)
-(void)showAlertWithMessage:(NSString*)message;
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message duration:(NSTimeInterval)time completion: (void (^)(void))completion;
@end

@interface UIViewController (Nice)
+(instancetype)instanceWithName:(NSString*)name;
@end


//快速创建来自storyboard的控制器
@interface UIViewController (IBHelper)
/*!
    用于创建来自Main storyboard 下storyboard id和本类的名字一样的的控制器
 */
+(instancetype)instanceFromIB;
+(instancetype)instanceFromStoryBoardName:(NSString*)storyBoardName;
+(instancetype)instanceFromStoryBoard:(UIStoryboard*)sb;
+(instancetype)instanceFromStoryBoard:(UIStoryboard*)sb name:(NSString*)name;
@end
