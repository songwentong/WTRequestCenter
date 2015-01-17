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
//        self.backgroundColor = [UIColor greenColor];
        self.imageURL = url;
        self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageButton.frame = self.bounds;
        _imageButton.contentMode = UIViewContentModeScaleAspectFit;
        
        [_imageButton setImageForState:UIControlStateNormal withURL:url];
        [self addSubview:_imageButton];
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
        myScrollView.contentSize = CGSizeMake(width*[urls count], height);
        myScrollView.pagingEnabled = YES;
        [self addSubview:myScrollView];
        
        self.imageUrls = urls;
        
        [_imageUrls enumerateObjectsUsingBlock:^(NSString* url, NSUInteger idx, BOOL *stop)
         {
             CGRect frame = CGRectMake(width*idx, 0, width, height);
             WTImageScrollView *scrollView = [[WTImageScrollView alloc] initWithFrame:frame imageURL:url];
             scrollView.maximumZoomScale = 4;
             scrollView.minimumZoomScale = 1;
             scrollView.delegate = self;
             [scrollView.imageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
             [imageViewArray addObject:scrollView];
             [myScrollView addSubview:scrollView];
             
             
         }];
        myScrollView.backgroundColor = [UIColor blackColor];
        
    }
    return self;
}


-(NSUInteger)currentPageIndex
{
    CGPoint p = myScrollView.contentOffset;
    NSInteger page = p.x/CGRectGetWidth(self.frame);
    return page;
}

-(void)buttonPressed:(UIButton*)sender
{
//    NSLog(@"%s",__func__);
    [_delegate WTImageViewer:self pressImageWithIndex:[self currentPageIndex]];
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
    if (_zoomEnable) {
        if ([scrollView isEqual:myScrollView]) {
            return nil;
        }else
        {
            WTImageScrollView *temp = (WTImageScrollView*)scrollView;
            return temp.imageButton;
        }
    }else
    {
        return nil;
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
