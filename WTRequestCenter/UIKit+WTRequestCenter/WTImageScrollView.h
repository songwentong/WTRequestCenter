//
//  WTImageScrollView.h
//  WTRequestCenter
//
//  Created by song on 14/10/18.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTImageScrollView : UIScrollView
{
    
}

-(instancetype)initWithFrame:(CGRect)frame imageURL:(NSString*)url;
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,readonly,copy) NSString *imageURL;
@end
