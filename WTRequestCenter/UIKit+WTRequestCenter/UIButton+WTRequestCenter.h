//
//  UIButton+WTImageCache.h
//  WTRequestCenter
//
//  Created by songwt on 14-7-30.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter
/*
 这是一个方便的缓存式网络请求的缓存库，在网络不好
 或者没有网络的情况下方便读取缓存来看。
 
 使用方法很简单，只需要传URL和参数就可以了。
 
 还提供上传图片功能，下载图片功能，缓存图片功能
 还有JSON解析功能，还提供来一个URL的表让你来填写
 然后直接快捷取URL。
 希望能帮到你，谢谢。
 如果有任何问题可以在github上向我提出
 Mike
 
 */

#import <UIKit/UIKit.h>
@class WTURLRequestOperation;
@interface UIButton (WTImageCache)

@property (nonatomic,strong) WTURLRequestOperation *wtImageRequestOperation;
@property (nonatomic,strong) WTURLRequestOperation *wtBackGroundImageRequestOperation;

- (void)setImageForState:(UIControlState)state
                 withURL:(NSString *)url;

- (void)setImageForState:(UIControlState)state
                 withURL:(NSString *)url
        placeholderImage:(UIImage *)placeholderImage;

- (void)setBackgroundImage:(UIControlState)state
                   withURL:(NSString *)url;

- (void)setBackgroundImage:(UIControlState)state
                   withURL:(NSString *)url
          placeholderImage:(UIImage *)placeholderImage;
@end
