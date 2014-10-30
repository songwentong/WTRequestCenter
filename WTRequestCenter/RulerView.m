//
//  RulerView.m
//  WTRequestCenter
//
//  Created by SongWentong on 14/10/30.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "RulerView.h"
#import "UIKit+WTRequestCenter.h"
#define leftMargin 10
@implementation RulerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
        
        
        [self configView];
        
        [self startAnimation];
    }
    return self;
}


-(void)configView
{
    animateView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin+7, 120, 2, 15)];
    animateView.backgroundColor = [UIColor WTcolorWithRed:58 green:181 blue:243 alpha:1];
    [self addSubview:animateView];
    
    
}

-(void)startAnimation
{

    NSTimeInterval duration = (random()%100)/100.0*1.0 + 0.3;
    
    
    CGFloat randomNumber = (random()%100)/100.0;

//    NSLog(@"duration:%f",duration);
    CGRect frame = animateView.frame;
    CGFloat height = CGRectGetHeight(self.frame);
    
    
    
    if (frame.origin.y<height/2) {
        frame.origin.y = height * (randomNumber*0.3+0.6);
    }else
    {
        frame.origin.y = height * (randomNumber*0.2+0.2);
    }
    
//    frame.origin.y = height*0.5 + randomNumber*randomNumber*randomNumber * height*0.5;
    
    randomNumber = (random()%100)/100.0;
    CGFloat speed = 240.0 * (randomNumber*0.5+0.9);
    
    duration = abs(frame.origin.y - animateView.frame.origin.y)/speed;
    [UIView animateWithDuration:duration delay:0.05 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        animateView.frame = frame;
    } completion:^(BOOL finished) {


        [self startAnimation];
    }];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(leftMargin, 0)];
    [path addLineToPoint:CGPointMake(leftMargin, CGRectGetMaxY(self.frame))];
    [path setLineWidth:2];
    
    
    UIColor *blueColor = [UIColor WTcolorWithRed:58 green:181 blue:243 alpha:1];
    [blueColor setStroke];
    [path stroke];
    
    
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat graduationHeight = 40;
    NSInteger numberOfGraduation = height/graduationHeight;
    for (int i=0; i<numberOfGraduation+1; i++) {
        [path moveToPoint:CGPointMake(leftMargin, graduationHeight*i)];

        [path addLineToPoint:CGPointMake(leftMargin+4, graduationHeight*i)];
        [path setLineWidth:1];
    }
    [path stroke];
    
}


@end
