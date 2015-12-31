//
//  UIImage+ImageCache.h
//  WTRequestCenter
//
//  Created by SongWentong on 12/31/15.
//  Copyright © 2015 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageCache)
+(NSBlockOperation*)imageOperationWithURL:(NSString*)url complection:(void(^)(UIImage *image,NSError *error))complection;
@end
