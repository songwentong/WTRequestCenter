#import <UIKit/UIKit.h>


@interface UIImage (WTRequestCenter)

// 根据颜色获取图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


#pragma mark - 建议的方法
//可缓存的，自动区分本地和网络的方法，建议用这个
+(void)gifImageWithURL:(NSURL*)url
            completion:(void(^)(UIImage* image))completion;

+(void)imageWithURL:(NSURL*)url
  comelectionHandler:(void(^)(UIImage* image))comelectionHandler;


#pragma mark - 不建议的方法
//+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)theData;

//+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)theURL;



@end
