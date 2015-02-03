//
//  NumberLabel.h
//  WTRequestCenter
//
//  Created by SongWentong on 15/2/3.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

//像余额宝一样的数字增长的label
@class NumberLabel;
@protocol NumberLabelDataSource <NSObject>

//当前数字
-(CGFloat)currentValueOfNumberLabel:(NumberLabel*)label;
//目标数字
-(CGFloat)targetValueOfNumberLabel:(NumberLabel*)label;

@optional
//动画时间，默认3秒
-(NSTimeInterval)animationTimeForNumberLabel:(NumberLabel*)label;
//显示的文字个数，默认100
-(NSUInteger)numberOfTextForNumberLabel:(NumberLabel*)label;

@end

//显示数字
@interface NumberLabel : UILabel

-(void)startAnimation;
@property(nonatomic,weak) id<NumberLabelDataSource> dataSource;
@end
