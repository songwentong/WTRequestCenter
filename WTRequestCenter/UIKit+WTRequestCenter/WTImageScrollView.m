//
//  WTImageScrollView.m
//  WTRequestCenter
//
//  Created by song on 14/10/18.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTImageScrollView.h"
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
