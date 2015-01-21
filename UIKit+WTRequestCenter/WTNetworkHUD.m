//
//  NetworkHUD.m
//  WTRequestCenter
//
//  Created by SongWentong on 15/1/21.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "WTNetworkHUD.h"
@interface WTNetworkHUD()
{
    NSMutableArray *circleArray;
    UIView *hudView;
    BOOL animating;
    NSInteger selectIndex;
    UIImageView *hudImageView;
    NSTimer *animateTimer;
}

@end


static CGFloat hudWidth = 150;
static CGFloat cornerRedius = 5;
static NSInteger numberOfArc = 8;

@implementation WTNetworkHUD

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initHud];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initHud];
    }
    return self;
}

-(void)initHud
{
    self.backgroundColor = [UIColor clearColor];
    circleArray = [[NSMutableArray alloc] init];
    hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, hudWidth, hudWidth)];
    hudView.layer.cornerRadius = cornerRedius;
    animating = NO;
    
    hudView.center = self.center;
    [self addSubview:hudView];
    
    selectIndex = 0;
    
    
    hudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self addSubview:hudView];
    
    animateTimer = [NSTimer timerWithTimeInterval:.12
                                           target:self
                                         selector:@selector(animate:)
                                         userInfo:nil
                                          repeats:YES];
    
    CGFloat angle = 2*M_PI / numberOfArc;
    for (int i=0; i<numberOfArc; i++) {
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center
                                                            radius:50
                                                        startAngle:angle * i endAngle:angle*(i+0.8)
                                                         clockwise:YES];
        
        path.lineWidth = numberOfArc;
        [circleArray addObject:path];
    }
    
}

- (void)drawRect:(CGRect)rect
{
    [circleArray enumerateObjectsUsingBlock:^(UIBezierPath *path, NSUInteger idx, BOOL *stop) {
        UIColor *stokeColor = nil;
        if (selectIndex==idx) {
            stokeColor = [self colorWithIndex:0];
        }else
        {
            stokeColor = [self colorWithIndex:3];
        }
        [stokeColor setStroke];
        [path stroke];
    }];
    

}

-(UIColor*)colorWithIndex:(NSInteger)index
{
    CGFloat color = 0.5+index*0.1;
    return [UIColor colorWithRed:color green:color blue:color alpha:1.0];
}

-(void)animate:(NSTimer*)timer
{
    selectIndex ++;
    if (selectIndex == numberOfArc) {
        selectIndex = 0;
    }
    [self setNeedsDisplay];
}

-(void)startAnimating
{
    if (!animating) {
        animating = YES;
        [[NSRunLoop currentRunLoop] addTimer:animateTimer
                                     forMode:NSRunLoopCommonModes];
        [animateTimer fire];
        
    }
}

-(void)stopAnimating
{
    animating = NO;
    [animateTimer invalidate];
}

-(void)reloadData
{
    if ([self.delegate respondsToSelector:@selector(wtNetWorkHUDImage:)]) {
        UIImage *image = [self.delegate wtNetWorkHUDImage:self];
        hudImageView.image = image;
    }

}

@end