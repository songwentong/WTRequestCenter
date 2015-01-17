//
//  WTImageViewer.h
//  WTRequestCenter
//
//  Created by song on 14/10/19.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WTImageScrollView : UIScrollView
{
    
}

-(instancetype)initWithFrame:(CGRect)frame imageURL:(NSString*)url;
@property (nonatomic,retain) UIButton *imageButton;
@property (nonatomic,readonly,copy) NSString *imageURL;
@end
@class WTImageViewer;
@protocol WTImageViewerDelegate <NSObject>

-(void)WTImageViewer:(WTImageViewer*)viewer pressImageWithIndex:(NSInteger)index;

@end
@interface WTImageViewer : UIView <UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    
    
    NSMutableArray *imageViewArray;
    
    
    NSMutableArray *buttonArray;
    
}
@property (nonatomic) BOOL zoomEnable;
@property (nonatomic,weak) id<WTImageViewerDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame urls:(NSArray*)urls;
@property (nonatomic,copy) NSArray *imageUrls;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger currentPageIndex;



@end
