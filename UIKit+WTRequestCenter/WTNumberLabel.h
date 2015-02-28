//
//  NumberLabel.h
//  WTRequestCenter
//
//  Created by SongWentong on 15/2/3.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

//像余额宝一样的数字增长的label
@class WTNumberLabel;
@protocol NumberLabelDataSource <NSObject>

//当前数字
-(CGFloat)currentValueOfNumberLabel:(WTNumberLabel*)label;
//目标数字
-(CGFloat)targetValueOfNumberLabel:(WTNumberLabel*)label;

@optional
//动画时间，默认3秒
-(NSTimeInterval)animationTimeForNumberLabel:(WTNumberLabel*)label;
//显示的文字个数，默认100
-(NSUInteger)numberOfTextForNumberLabel:(WTNumberLabel*)label;

@end

//显示数字
@interface WTNumberLabel : UILabel

-(void)startAnimation;
@property(nonatomic,weak) id<NumberLabelDataSource> dataSource;
@end
