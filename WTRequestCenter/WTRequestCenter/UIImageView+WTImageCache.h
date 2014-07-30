//
//  UIImageView+WTImageCache.h
//  WTRequestCenter
//
//  Created by songwt on 14-7-30.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WTImageCache)
//下载图片
- (void)setImageWithURL:(NSURL *)url;
//下载图片＋placeholder
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
