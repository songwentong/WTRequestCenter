//
//  NetworkHUD.m
//  WTRequestCenter
//
//  Created by SongWentong on 15/1/21.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "WTNetworkHUD.h"
#import "UIScreen+WTRequestCenter.h"
@interface WTNetworkHUD()
{
    
//    8个圆弧的贝塞尔曲线
    NSMutableArray *circleArray;
    
//    hud的背景图
    UIView *hudView;
    
//    是否在动画
    BOOL animating;
//    当前索引
    NSInteger selectIndex;
    
//    hud图片  ，如果没有未来考虑drawRect绘制一个
    UIImageView *hudImageView;
    
//    timer
    NSTimer *animateTimer;
}

@end

//hud宽度
static CGFloat hudWidth = 150;
//角半径
static CGFloat cornerRedius = 5;
//圆弧的数量
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
    hudView.backgroundColor = [UIColor clearColor];
    hudView.center = self.center;
    [self addSubview:hudView];
    
    selectIndex = 0;
    
    
    hudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    hudImageView.hidden = YES;
    [self addSubview:hudView];
    
    animateTimer = [NSTimer timerWithTimeInterval:.12
                                           target:self
                                         selector:@selector(animate:)
                                         userInfo:nil
                                          repeats:YES];
    
    CGFloat angle = 2*M_PI / numberOfArc;
    for (int i=0; i<numberOfArc; i++) {
        CGPoint center = CGPointMake([UIScreen screenWidth]/2, [UIScreen screenHeight]/2);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:50
                                                        startAngle:angle * i endAngle:angle*(i+0.8)
                                                         clockwise:YES];
        
        path.lineWidth = numberOfArc;
        [circleArray addObject:path];
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    hudView.center = CGPointMake([UIScreen screenWidth]/2, [UIScreen screenHeight]/2);
    hudView.hidden = YES;
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


// 循环获取数组中的数据，不会越界
-(NSInteger)indexForIndex:(NSInteger)index Stride:(NSInteger)stride
{
    NSInteger result = index + stride;
    
    if (result>=numberOfArc) {
        result = result % numberOfArc;
    }
    if (result<0) {
        result = result + numberOfArc;
    }
    
    return result;
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
    CGRect rect = [UIScreen mainScreen].bounds;
    hudImageView.center = CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect)/2);
//    NSLog(@"%@",hudImageView);
    [self setNeedsDisplay];
}

-(void)startAnimating
{
    if (!animating) {
        animating = YES;
        [[NSRunLoop currentRunLoop] addTimer:animateTimer
                                     forMode:NSRunLoopCommonModes];
        [animateTimer fire];
        
        
        if ([self.delegate respondsToSelector:@selector(wtNetWorkHUDImage:)]) {
            UIImage *image = [self.delegate wtNetWorkHUDImage:self];
            hudImageView.image = image;
            
            hudImageView.backgroundColor = [UIColor redColor];
        }
    }
}

-(void)stopAnimating
{
    animating = NO;
    [animateTimer invalidate];
    self.hidden = YES;
}

-(void)reloadData
{
    

}

@end