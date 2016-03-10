//
//  UIView+Nice.m
//  WTRequestCenter
//
//  Created by SongWentong on 3/10/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "UIView+Nice.h"
#import "CALayer+Nice.h"
@implementation UIView (Nice)
- (UIImage *)snapshotImage
{
    return self.layer.snapshotImage;
}
@end
