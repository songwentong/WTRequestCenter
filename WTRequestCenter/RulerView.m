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
        
        [self configModel];
        
        [self configView];
        
        [self startAnimation];
    }
    return self;
}


-(void)configModel
{
    animationIndex = 0;
}

-(void)configView
{
    animateView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin+7, 120, 2, 15)];
    animateView.backgroundColor = [UIColor WTcolorWithRed:58 green:181 blue:243 alpha:1];
    [self addSubview:animateView];
    
    
}

-(NSArray*)yArray
{
    return @[@"100",@"300",@"100",@"120",@"200",@"80",@"305",@"50",@"250",@"100",];
}

-(void)startAnimation
{


    CGRect frame = animateView.frame;
    CGFloat speed = 100;
    animationIndex = animationIndex +1;
    if (animationIndex == [[self yArray] count]-1) {
        animationIndex = 0;
    }
    NSString *str = [self yArray][animationIndex];
    frame.origin.y = [str floatValue];

    
    /*
    [UIView animateWithDuration:1.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        animateView.frame = frame;
    } completion:^(BOOL finished) {


        [self startAnimation];
    }];
     */
    

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :0.15 :0.85 :0.5];
    animation.duration = 1.0;
    animation.fromValue = [NSValue valueWithCGPoint:animateView.center];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(20, frame.origin.y)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;
    animation.delegate = self;
    [animateView.layer addAnimation:animation forKey:@"aa"];
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self startAnimation];
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
