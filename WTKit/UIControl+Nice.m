//
//  UIControl+Nice.m
//  WTRequestCenter
//
//  Created by SongWentong on 3/21/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "UIControl+Nice.h"
#import <objc/runtime.h>

@implementation UIControl (Nice)
-(NSArray*)methodList
{
    return @[];
}

-(void)addtargetforControlEventsTouchUpInside:(dispatch_block_t)block{
    objc_setAssociatedObject(self, "touchUpInside", block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self addTarget:self action:@selector(methodUIControlEventTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)methodUIControlEventTouchUpInside:(id)sender{
    dispatch_block_t block = objc_getAssociatedObject(self, "touchUpInside");
    if (block) {
        block();
    }
}


@end
