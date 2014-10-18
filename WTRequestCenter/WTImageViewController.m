//
//  WTImageViewController.m
//  WTRequestCenter
//
//  Created by song on 14/10/18.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTImageViewController.h"
#import "UIKit+WTRequestCenter.h"
#import "WTImageViewer.h"
@interface WTImageViewController ()

@end

@implementation WTImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configModel];
    [self configView];
    
}

-(void)configModel
{
    imageViewArray = [[NSMutableArray alloc] init];
}

-(void)configView
{
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    myScrollView.delegate = self;
    CGFloat height = 500;
    myScrollView.contentSize = CGSizeMake(320*[_imageUrls count], height);
    myScrollView.pagingEnabled = YES;
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
    [self.view addSubview:myScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
