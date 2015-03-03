//
//  CycleScrollView.h
//  QuantGroup
//
//  Created by SongWentong on 15/2/3.
//  Copyright (c) 2015年 Spritekit. All rights reserved.
//

/*
 
 循环的ScrollView
 */


#import <UIKit/UIKit.h>
@class WTCycleScrollView;
@protocol WTCycleScrollViewDataSource <NSObject>

-(NSInteger)numberOfViewInCycleScrollView:(WTCycleScrollView*)view;
-(UIView*)cycleScrollView:(WTCycleScrollView*)view viewForIndex:(NSInteger)index;

@end
@interface WTCycleScrollView : UIView
@property (weak ,nonatomic) id <WTCycleScrollViewDataSource> dataSource;
-(void)reloadData;


@end
