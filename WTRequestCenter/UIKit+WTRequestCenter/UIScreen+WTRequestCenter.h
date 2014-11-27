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
 把长度换算成320的标准
 */
+(CGFloat)convertWidthTo320Standard:(CGFloat)width;


/*!
 把点换算成320的标准
 */
+(CGPoint)converPointTo320Standard:(CGPoint)point;


/*!
 把Rect换算成320的标准
 */
+(CGRect)converRectTo320Standard:(CGRect)rect;
@end
