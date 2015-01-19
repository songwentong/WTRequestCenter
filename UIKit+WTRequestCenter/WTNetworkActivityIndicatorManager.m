//
//  WTNetworkActivityIndicatorManager.m
//  WTRequestCenter
//
//  Created by song on 14/10/24.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTNetworkActivityIndicatorManager.h"
#import "WTRequestCenter.h"
@interface WTNetworkActivityIndicatorManager ()
@property (readwrite, nonatomic, assign) NSInteger activityCount;
@property (readwrite, nonatomic, strong) NSTimer *activityIndicatorVisibilityTimer;
@end
//状态管理工具
@implementation WTNetworkActivityIndicatorManager

+ (instancetype)sharedManager{
    static WTNetworkActivityIndicatorManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self handleNotifications];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)handleNotifications
{
    [[NSNotificationCenter defaultCenter] addObserverForName:WTNetworkingOperationDidStartNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
    {

            [self incrementActivityCount];
        
    }];
    

    
    [[NSNotificationCenter defaultCenter] addObserverForName:WTNetworkingOperationDidFinishNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
    {
            [self decrementActivityCount];
    }];
}

+(NSURLRequest*)requestFromNotification:(NSNotification*)notification
{
    if ([[notification object] isKindOfClass:[NSURLRequest class]]) {
        return [notification object];
    }
    return nil;
}

- (void)incrementActivityCount {
    [self willChangeValueForKey:@"activityCount"];
    @synchronized(self) {
        _activityCount++;
    }

    [self didChangeValueForKey:@"activityCount"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateNetworkActivityIndicatorVisibilityDelayed];
    });
}



- (void)decrementActivityCount {
    [self willChangeValueForKey:@"activityCount"];
    @synchronized(self) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
        _activityCount = MAX(_activityCount - 1, 0);
#pragma clang diagnostic pop
    }
    [self didChangeValueForKey:@"activityCount"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateNetworkActivityIndicatorVisibilityDelayed];
    });
}

- (BOOL)isNetworkActivityIndicatorVisible {

    return self.activityCount > 0;
}
- (void)updateNetworkActivityIndicatorVisibilityDelayed {
    if (self.enabled) {
        // Delay hiding of activity indicator for a short interval, to avoid flickering
        
        if (![self isNetworkActivityIndicatorVisible]) {
            
            [self.activityIndicatorVisibilityTimer invalidate];
            
            self.activityIndicatorVisibilityTimer = [NSTimer timerWithTimeInterval:0.17
                                                                            target:self
                                                                          selector:@selector(updateNetworkActivityIndicatorVisibility)
                                                                          userInfo:nil
                                                                           repeats:NO];
            
            [[NSRunLoop mainRunLoop] addTimer:self.activityIndicatorVisibilityTimer
                                      forMode:NSRunLoopCommonModes];
            
        } else {
            [self performSelectorOnMainThread:@selector(updateNetworkActivityIndicatorVisibility)
                                   withObject:nil
                                waitUntilDone:NO
                                        modes:@[NSRunLoopCommonModes]];
        }
    }
}

- (void)updateNetworkActivityIndicatorVisibility {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[self isNetworkActivityIndicatorVisible]];
}

@end
