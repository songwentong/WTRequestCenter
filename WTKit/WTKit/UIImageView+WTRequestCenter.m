//
//  UIImageView+WTImageCache.m
//  WTRequestCenter
//
//  Created by song on 14-7-19.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter


#import <objc/runtime.h>
#import "WTNetWorkManager.h"
#import "UIImage+Nice.h"
#import "NSObject+Nice.h"
@import ImageIO;
@import UIKit;
@interface UIImageView()

@end
@implementation UIImageView (ImageCache)
static const void * const WTImageViewOperationKey = @"WT ImageView Operation Key";

static const void * const WTHighlightedImageOperationKey = @"WT Highlighted Image Operation Key";


-(void)setImageOperation:(WTURLSessionDataTask*)operation
{
    WTURLSessionDataTask *old = [self imageOperation];
    [old cancel];
    
    objc_setAssociatedObject(self, WTImageViewOperationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(WTURLSessionDataTask*)imageOperation{
    return objc_getAssociatedObject(self, WTImageViewOperationKey);
}




- (void)setImageWithURL:(NSString *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    
    [self setImageWithURL:url placeholderImage:placeholder finished:nil failed:nil];
}

-(void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder finished:(dispatch_block_t)finished failed:(void(^)(NSError*error))failed
{

    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
    {
        self.image = placeholder;
    }];
    
    
    NSMutableURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    WTURLSessionDataTask *task = (WTURLSessionDataTask*)[[WTNetWorkManager sharedKit] cachedDataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            safeSyncInMainQueue(^{
                if (image) {
                    self.image = image;
                    [self setNeedsLayout];
                    if (finished) {
                        finished();
                    }
                }
            });
        }else{
            if (failed) {
                failed(error);
            }
        }
    }];
    [self setImageOperation:task];
    
    
}




@end

@implementation UIImageView(highlightedImage)

-(void)setHighlightedImageOperation:(WTURLSessionDataTask*)operation
{
    WTURLSessionDataTask *old = [self highlightedImageOperation];
    [old cancel];
    objc_setAssociatedObject(self, WTHighlightedImageOperationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(WTURLSessionDataTask*)highlightedImageOperation{
    return objc_getAssociatedObject(self, WTHighlightedImageOperationKey);
}

-(void)setHighlightedImageWithURL:(NSString *)url
{
    [self setHighlightedImageWithURL:url
                    placeholderImage:nil];
}

-(void)setHighlightedImageWithURL:(NSString *)url placeholderImage:(UIImage*)placeholderImage
{
    [self setHighlightedImageWithURL:url placeholderImage:placeholderImage finished:nil failed:nil];
}

-(void)setHighlightedImageWithURL:(NSString *)url placeholderImage:(UIImage*)placeholderImage finished:(dispatch_block_t)finished failed:(dispatch_block_t)failed
{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
     {
         self.highlightedImage = placeholderImage;
     }];
    
    
   
    
    
    
    WTURLSessionDataTask *operation = [UIImage imageCacheTaskWithURL:url complection:^(UIImage * _Nullable image, NSError * _Nullable error) {
        safeSyncInMainQueue(^{
            self.highlightedImage = image;
            [self setNeedsLayout];
            if (finished) {
                finished();
            }
        });
    }];
    
    [self setHighlightedImageOperation:operation];
    [operation resume];
}


@end

@implementation UIImageView(Gif)
-(void)setGifWithURL:(NSString*)url
{
    NSMutableURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    [[WTNetWorkManager sharedKit] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            [self setGifWithData:data];
        }
    }];
}


//给出数据,设置gif
-(void)setGifWithData:(NSData*)data{
    UIImage *image = [[self class] sd_animatedGIFWithData:data];
    self.image = image;
}

+ (UIImage *)sd_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            duration += [self sd_frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

+ (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}



@end


