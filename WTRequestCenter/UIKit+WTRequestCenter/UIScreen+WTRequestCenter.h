//
//  UIScreen+WTRequestCenter.h
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/27.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (WTRequestCenter)
//屏幕宽度
+(CGFloat)screenWidth;

//屏幕高度
+(CGFloat)screenHeight;

//屏幕大小
+(CGSize)screenSize;

/*!
 把320标准换算成当前屏幕标准
 */
+(CGFloat)convert320ToCurrentWidth:(CGFloat)width;

/*!
 把320标准的点换算成当前屏幕标准
 */
+(CGPoint)convert320ToCurrentPoint:(CGPoint)point;


/*!
 把320标准换算成当前屏幕标准
 */
+(CGRect)convert320ToCurrentRect:(CGRect)rect;
@end
