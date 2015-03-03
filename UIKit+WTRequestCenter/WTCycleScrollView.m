//
//  CycleScrollView.m
//  QuantGroup
//
//  Created by SongWentong on 15/2/3.
//  Copyright (c) 2015年 Spritekit. All rights reserved.
//

#import "WTCycleScrollView.h"
@interface WTCycleScrollView() <UIScrollViewDelegate>
{
    NSTimer *myTimer;
    
    //    动画时间间隔
    NSTimeInterval runTimeInterval;
    
    
    //    要展示的UI
    NSMutableArray *viewToShow;
    
    
    UIScrollView *myScrollView;
    
}
@end
@implementation WTCycleScrollView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configModelAndViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configModelAndViews];
    }
    return self;
}

-(void)configModelAndViews
{
    runTimeInterval = 3;
    viewToShow = [[NSMutableArray alloc] init];
    myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    myScrollView.bounces = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.delegate = self;
    myScrollView.pagingEnabled = YES;
    [self addSubview:myScrollView];
    
    
}

-(void)setDataSource:(id<WTCycleScrollViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}
-(CGFloat)width
{
    return CGRectGetWidth(self.bounds);
}
-(void)run:(NSTimer*)timer
{
//    NSLog(@"run");
    [self updatePosition];
    CGPoint contentOffset = myScrollView.contentOffset;
    if (contentOffset.x == myScrollView.contentSize.width-[self width]) {
        contentOffset.x = [self width];
    }else
    {
        contentOffset.x += [self width];
    }
    [UIView animateWithDuration:0.5
                          delay:0
                        options:0
                     animations:^{
                         myScrollView.contentOffset = contentOffset;
                     } completion:^(BOOL finished) {
                         [self updatePosition];
                     }];
    //    [myScrollView setContentOffset:contentOffset
    //                          animated:YES];
}

-(void)updatePosition
{
    CGPoint contentOffset = myScrollView.contentOffset;
    if (contentOffset.x == myScrollView.contentSize.width-[self width]) {
        contentOffset.x = [self width];
        
    }
    
    if (contentOffset.x == 0) {
        contentOffset.x = myScrollView.contentSize.width - 2*[self width];
        
    }
    
    [myScrollView setContentOffset:contentOffset
                          animated:NO];
    
}

- (void)dealloc
{
    self.dataSource = nil;
}



-(void)reloadData
{
    NSInteger count = [self.dataSource numberOfViewInCycleScrollView:self];
    if (count>0) {
        [viewToShow enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [view removeFromSuperview];
        }];
        
        [viewToShow removeAllObjects];
        
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        myScrollView.contentSize = CGSizeMake(width*(count+2), height);
        myScrollView.contentOffset = CGPointMake(width, 0);
        
        for (int i=0; i< count; i++) {
            UIView *view = [self.dataSource cycleScrollView:self
                                               viewForIndex:i];
            CGRect frame = CGRectMake((i+1)*width, 0, width, height);
            [viewToShow addObject:view];
            view.frame = frame;
            [myScrollView addSubview:view];
        }
        UIView *first = [self.dataSource cycleScrollView:self
                                            viewForIndex:0];
        first.frame = CGRectMake((count+1)*width, 0, width, height);
        [myScrollView addSubview:first];
        
        UIView *last = [self.dataSource cycleScrollView:self
                                           viewForIndex:count-1];
        last.frame = CGRectMake(0, 0, width, height);
        [myScrollView addSubview:last];
        
        
        
        
        [self startTimer];
        
    }
}


-(void)startTimer
{
    [myTimer invalidate];
    myTimer = [NSTimer timerWithTimeInterval:runTimeInterval
                                      target:self
                                    selector:@selector(run:)
                                    userInfo:nil
                                     repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:myTimer
                                 forMode:NSDefaultRunLoopMode];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [myTimer invalidate];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePosition];
    [self startTimer];
}

@end
