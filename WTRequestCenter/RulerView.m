//
//  RulerView.m
//  WTRequestCenter
//
//  Created by SongWentong on 14/10/30.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "RulerView.h"
#import "UIKit+WTRequestCenter.h"
const CGFloat leftMargin = 10;
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
    
//    33 202 206
    
    UIColor *blueColor = [UIColor WTcolorWithRed:81 green:200 blue:236];
    
    animateView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin+7, 120, 4, 15)];
    animateView.backgroundColor = blueColor;
    [self addSubview:animateView];
    
    
    animateView2 = [[UIView alloc] initWithFrame:CGRectMake(leftMargin+1, 150, 4, 4)];
    [self addSubview:animateView2];
    animateView2.backgroundColor = blueColor;
    
    animateView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
    [self addSubview:animateView3];
    animateView3.backgroundColor = blueColor;
    
}

-(NSArray*)yArray
{
    return @[@"100",@"300",@"100",@"120",@"200",@"80",@"305",@"150",@"250",@"100",];
}

-(NSArray*)yArray2
{
    return @[@"240",@"100",@"350",@"100",@"140",@"400",@"80",@"380",@"80",@"240",];
}


-(NSArray*)yArray3
{
    return @[@"150",@"360",@"100",@"80",@"460",@"90",@"70",@"280",@"350",@"150",];
}
-(void)startAnimation
{


    CGRect frame = animateView.frame;
    animationIndex = animationIndex +1;
    if (animationIndex == [[self yArray] count]-1) {
        animationIndex = 0;
    }
    NSString *str = [self yArray][animationIndex];
    frame.origin.y = [str floatValue];
    
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [[self yArray] enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL *stop) {
        CGPoint p = CGPointMake(leftMargin+6, [string floatValue]);
        NSValue *value = [NSValue valueWithCGPoint:p];
        [values addObject:value];
    }];
    
    
    
    NSMutableArray *timingFunctions = [NSMutableArray new];
    [[self yArray] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CAMediaTimingFunction* timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4 :0.3 :0.6 :0.7];
        timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [timingFunctions addObject:timingFunction];
    }];
    keyFrameAnimation.timingFunctions = timingFunctions;
    
    keyFrameAnimation.duration = 12;
    keyFrameAnimation.values = values;
    keyFrameAnimation.fillMode = kCAFillModeBoth;
    keyFrameAnimation.removedOnCompletion = NO;
    keyFrameAnimation.delegate = self;
    [animateView.layer addAnimation:keyFrameAnimation forKey:nil];
    
    
    
    
    
    
    CAKeyframeAnimation *keyFrameAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [values removeAllObjects];
    [[self yArray2] enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL *stop) {
        CGPoint p = CGPointMake(leftMargin+2, [string floatValue]);
        NSValue *value = [NSValue valueWithCGPoint:p];
        [values addObject:value];
    }];
    keyFrameAnimation2.timingFunctions = timingFunctions;
    
    keyFrameAnimation2.duration = 12;
    keyFrameAnimation2.values = values;
    keyFrameAnimation2.fillMode = kCAFillModeBoth;
    keyFrameAnimation2.removedOnCompletion = NO;
    [animateView2.layer addAnimation:keyFrameAnimation2 forKey:nil];

    
    
    
    CAKeyframeAnimation *keyFrameAnimation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [values removeAllObjects];
    [[self yArray3] enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL *stop) {
        CGPoint p = CGPointMake(leftMargin+10, [string floatValue]);
        NSValue *value = [NSValue valueWithCGPoint:p];
        [values addObject:value];
    }];
    keyFrameAnimation3.timingFunctions = timingFunctions;
    
    keyFrameAnimation3.duration = 12;
    keyFrameAnimation3.values = values;
    keyFrameAnimation3.fillMode = kCAFillModeBoth;
    keyFrameAnimation3.removedOnCompletion = NO;
    [animateView3.layer addAnimation:keyFrameAnimation3 forKey:nil];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
//        [animateView.layer removeAllAnimations];
    [self startAnimation];
    }

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

-(void)layoutSubviews
{
    [super layoutSubviews];
    NSArray *animationKeys = [animateView.layer animationKeys];
    NSLog(@"%@",animationKeys);

}


@end
