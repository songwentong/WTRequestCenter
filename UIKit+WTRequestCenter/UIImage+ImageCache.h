//
//  UIImage+ImageCache.h
//  WTRequestCenter
//
//  Created by SongWentong on 12/31/15.
//  Copyright © 2015 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageCache)

//根据图片的URL给出一个operation对象,会返回一个图片和失败的装填
+(NSBlockOperation*)imageOperationWithURL:(NSString*)url
                              complection:(void(^)(UIImage *image,NSError *error))complection;
//删除图片
+(void)removeImageWithURL:(NSString*)url;
//删除所有图片
+(void)clearAllImages;
@end
