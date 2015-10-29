//
//  ImageViewCacheVC.m
//  WTRequestCenter
//
//  Created by SongWentong on 10/29/15.
//  Copyright © 2015 song. All rights reserved.
//

#import "ImageViewCacheVC.h"
#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
@interface ImageViewCacheVC ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@end

@implementation ImageViewCacheVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestUseDefaultURL:(id)sender {
    _myTextField.text = @"http://img0.bdstatic.com/img/image/c9e2596284f50ce95cbed0d756fdd22b1409207983.jpg";
    [self requestWithURL:_myTextField.text];
}


-(void)requestWithURL:(NSString*)url
{
    [_activity startAnimating];
    [_myTextField resignFirstResponder];
    [_myImageView setImageWithURL:url placeholderImage:nil finished:^{
        [_activity stopAnimating];
    } failed:^{
        [_activity stopAnimating];
        
    }];
}

- (IBAction)requestImage:(id)sender {
    [self requestUseDefaultURL:_myTextField.text];
}
- (IBAction)cleanImage:(id)sender {
    _myImageView.image = nil;
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
