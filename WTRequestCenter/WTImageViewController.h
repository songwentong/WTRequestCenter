//
//  WTImageViewController.h
//  WTRequestCenter
//
//  Created by song on 14/10/18.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTImageViewController : UIViewController <UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    
    
    NSMutableArray *imageViewArray;
}
@property (nonatomic,copy) NSArray *imageUrls;
@end
