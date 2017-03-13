//
//  UIImage+ImageCache.h
//  WTRequestCenter
//
//  Created by SongWentong on 12/31/15.
//  Copyright © 2015 song. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIImage (ImageCache)

//根据图片的URL给出一个operation对象,会返回一个图片和失败的装填
+(NSBlockOperation*)imageOperationWithURL:(NSString*)url
                              complection:(void(^)(UIImage *image,NSError *error))complection;
//删除图片
+(void)removeImageWithURL:(NSString*)url;
//删除所有图片
+(void)clearAllImages;
//图片解码
+ (nullable UIImage *)decodedImageWithImage:(nullable UIImage *)image;
@end

@interface UIImage (Gif)
+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)data;
+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)url;
+(void)gifImageWithURL:(NSString*)url
            completion:(void(^)(UIImage* image))completion;
@end
NS_ASSUME_NONNULL_END
