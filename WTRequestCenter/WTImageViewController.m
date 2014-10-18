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
}

-(void)configView
{
    WTImageViewer *viewer = [[WTImageViewer alloc] initWithFrame:CGRectMake(0, 0, 320, 568) urls:_imageUrls];
    viewer.zoomEnable = YES;
    [self.view addSubview:viewer];
    viewer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WTImageViewerDelegate
-(void)WTImageViewer:(WTImageViewer*)viewer pressImageWithIndex:(NSInteger)index
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
