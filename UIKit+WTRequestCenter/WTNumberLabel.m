//
//  NumberLabel.m
//  WTRequestCenter
//
//  Created by SongWentong on 15/2/3.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "WTNumberLabel.h"
#import <CoreGraphics/CoreGraphics.h>
@interface WTNumberLabel()
{
    NSTimer *_myTimer;
    NSInteger _currintIndex;
    
    NSUInteger _strideCount;
    
    NSMutableArray *_pointsArray;
    
    NSTimeInterval _timerTimeInterval;
}
@end
CGPoint PointOnCubicBezier( CGPoint* cp, float t )
{
    //    x = (1-t)^3 *x0 + 3*t*(1-t)^2 *x1 + 3*t^2*(1-t) *x2 + t^3 *x3
    //    y = (1-t)^3 *y0 + 3*t*(1-t)^2 *y1 + 3*t^2*(1-t) *y2 + t^3 *y3
    float   ax, bx, cx;
    float   ay, by, cy;
    float   tSquared, tCubed;
    CGPoint result;
    
    /*計算多項式係數*/
    
    cx = 3.0 * (cp[1].x - cp[0].x);
    bx = 3.0 * (cp[2].x - cp[1].x) - cx;
    ax = cp[3].x - cp[0].x - cx - bx;
    
    cy = 3.0 * (cp[1].y - cp[0].y);
    by = 3.0 * (cp[2].y - cp[1].y) - cy;
    ay = cp[3].y - cp[0].y - cy - by;
    
    /*計算位於參數值t的曲線點*/
    
    tSquared = t * t;
    tCubed = tSquared * t;
    
    result.x = (ax * tCubed) + (bx * tSquared) + (cx * t) + cp[0].x;
    result.y = (ay * tCubed) + (by * tSquared) + (cy * t) + cp[0].y;
    
    return result;
}

@implementation WTNumberLabel


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configModelAndView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configModelAndView];
    }
    return self;
}

-(void)configModelAndView
{
    _pointsArray = [[NSMutableArray alloc] init];
    _currintIndex = 0;
}

-(void)startAnimation
{
    //当前数字
    CGFloat currentValue = [self.dataSource currentValueOfNumberLabel:self];
    //目标数字
    CGFloat targetValue = [self.dataSource targetValueOfNumberLabel:self];
    //显示的次数
    CGFloat textNumber = 50;
    
    if ([self.dataSource respondsToSelector:@selector(numberOfTextForNumberLabel:)]) {
        textNumber = [self.dataSource numberOfTextForNumberLabel:self];
    }
    
    _strideCount = textNumber;
    _currintIndex = 0;
    CGFloat animationTime = 1.0;
    if ([self.dataSource respondsToSelector:@selector(animationTimeForNumberLabel:)]) {
        animationTime = [self.dataSource animationTimeForNumberLabel:self];
    }
    
    
    self.text = [NSString stringWithFormat:@"%.2f",currentValue];
    
    [_pointsArray removeAllObjects];
    CGPoint points[4] = {CGPointZero,CGPointMake(0.5, 0.9),CGPointMake(0.7, 0.95),CGPointMake(1, 1)};
    CGFloat dt = 1.0/(textNumber+1);
    
    _timerTimeInterval = animationTime / textNumber;
    for (int i=0; i<textNumber; i++) {
        CGPoint p = PointOnCubicBezier(points, i*dt);
        NSTimeInterval duration = p.x * animationTime;
        CGFloat value = p.y * (targetValue - currentValue) + currentValue;
        NSArray *tempArray = @[[NSNumber numberWithFloat:duration],[NSNumber numberWithFloat:value]];
        [_pointsArray addObject:tempArray];
    }
    [self start];
    
}

-(void)start
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:_timerTimeInterval
                                             target:self
                                           selector:@selector(run:) userInfo:nil
                                            repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer
                                 forMode:NSRunLoopCommonModes];
    
}


-(void)run:(NSTimer*)timer
{
    if (_currintIndex >= _strideCount) {
        self.text = [NSString stringWithFormat:@"%.2f",[self.dataSource targetValueOfNumberLabel:self]];
        [timer invalidate];
    }else
    {
        NSArray *pointValues = [_pointsArray objectAtIndex:_currintIndex];
        _currintIndex ++;
        CGFloat value = [pointValues[1] floatValue];
        //        CGFloat currentTime = [(NSNumber *)[pointValues objectAtIndex:0] floatValue];
        //        NSTimeInterval timeDuration = currentTime - lastTime;
        self.text = [NSString stringWithFormat:@"%.2f",value];
        [self start];
        
    }
}
@end

