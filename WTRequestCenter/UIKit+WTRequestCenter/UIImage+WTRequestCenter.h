#import <UIKit/UIKit.h>

/**
        UIImage (animatedGIF)
        
    This category adds class methods to `UIImage` to create an animated `UIImage` from an animated GIF.
*/
@interface UIImage (WTRequestCenter)

#pragma mark - 建议的方法
/*!
 可缓存的，自动区分本地和网络的方法，建议用这个
 */
+(void)gifImageWithURL:(NSString*)url
            completion:(void(^)(UIImage* image))completion;


/*!
    通常不会直接用到的方法
 */
+(void)imageWithURL:(NSString*)url
 comelectionHandler:(void(^)(UIImage* image))comelectionHandler;


/*!
 通常不会直接用到的方法，作为UIImageView和UIButton的辅助方法
 */
+(void)imageWithData:(NSData *)data complectionHandler:(void(^)(UIImage *image))complection;

//对UIView进行快照
+ (UIImage *)snapshot:(UIView *)view;






@end
