//
//  CALayer+Nice.h
//  WTRequestCenter
//
//  Created by SongWentong on 3/10/16.
//  Copyright © 2016 song. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN
@import QuartzCore;
@class CALayer;
@class UIImage;
@interface CALayer (Nice)
- (UIImage *)snapshot;
@end
NS_ASSUME_NONNULL_END