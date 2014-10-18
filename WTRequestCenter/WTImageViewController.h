//
//  WTImageViewController.h
//  WTRequestCenter
//
//  Created by song on 14/10/18.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTImageViewer.h"
@interface WTImageViewController : UIViewController <UIScrollViewDelegate,WTImageViewerDelegate>
{

}
@property (nonatomic,copy) NSArray *imageUrls;
@end
