#import <UIKit/UIKit.h>

/**
        UIImage (animatedGIF)
        
    This category adds class methods to `UIImage` to create an animated `UIImage` from an animated GIF.
*/
@interface UIImage (animatedGIF)

#pragma mark - 建议的方法
//可缓存的，自动区分本地和网络的方法，建议用这个
+(void)animatedImageWithAnimatedGIFURL:(NSURL*)url
                            completion:(void(^)(UIImage* image))completion;


#pragma mark - 不建议的方法
+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)theData;

+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)theURL;



@end
