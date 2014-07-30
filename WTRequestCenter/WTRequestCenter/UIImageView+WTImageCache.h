//
//  UIImageView+WTImageCache.h
//  WTRequestCenter
//
//  Created by song on 14-7-19.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import <UIKit/UIKit.h>

@interface UIImageView (WTImageCache)
//下载图片
- (void)setImageWithURL:(NSURL *)url;
//下载图片＋placeholder
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
