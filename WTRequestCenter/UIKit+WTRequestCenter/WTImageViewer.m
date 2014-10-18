//
//  WTImageViewer.m
//  WTRequestCenter
//
//  Created by song on 14/10/19.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTImageViewer.h"
#import "UIKit+WTRequestCenter.h"


@interface WTImageScrollView()
@property (nonatomic,copy,readwrite) NSString *imageURL;
@end
@implementation WTImageScrollView
-(instancetype)initWithFrame:(CGRect)frame imageURL:(NSString*)url
{
    self = [self initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        self.imageURL = url;
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView setImageWithURL:url placeholderImage:nil finished:^(NSURLResponse *response, NSData *data, UIImage *image) {
            NSLog(@"xxx");
        }];
        [self addSubview:_imageView];
    }
    return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
@implementation WTImageViewer
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame urls:(NSArray*)urls
{
    self = [self initWithFrame:frame];
    if (self) {
        imageViewArray = [[NSMutableArray alloc] init];
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        myScrollView = [[UIScrollView alloc] initWithFrame:frame];
        myScrollView.delegate = self;
        myScrollView.contentSize = CGSizeMake(320*width, height);
        myScrollView.pagingEnabled = YES;
        [self addSubview:myScrollView];
        
        self.imageUrls = urls;
        
        [_imageUrls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_imageUrls enumerateObjectsUsingBlock:^(NSString* url, NSUInteger idx, BOOL *stop)
             {
                 CGRect frame = CGRectMake(320*idx, 0, 320, height);
                 WTImageScrollView *scrollView = [[WTImageScrollView alloc] initWithFrame:frame imageURL:url];
                 scrollView.maximumZoomScale = 4;
                 scrollView.minimumZoomScale = 1;
                 scrollView.delegate = self;
                 [imageViewArray addObject:scrollView];
                 [myScrollView addSubview:scrollView];
             }];
            myScrollView.backgroundColor = [UIColor redColor];
        }];
        
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:myScrollView]) {
        [imageViewArray enumerateObjectsUsingBlock:^(WTImageScrollView *tempScrollView, NSUInteger idx, BOOL *stop) {
            tempScrollView.zoomScale = 1.0;
        }];
    }
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    //    NSInteger page = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    if ([scrollView isEqual:myScrollView]) {
        return nil;
    }else
    {
        WTImageScrollView *temp = (WTImageScrollView*)scrollView;
        return temp.imageView;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
