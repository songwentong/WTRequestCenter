//
//  WTRequestViewController.m
//  WTRequestCenter
//
//  Created by SongWentong on 14-10-15.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTRequestViewController.h"
#import "WTRequestCenter.h"
@interface WTRequestViewController ()

@end

@implementation WTRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [WTRequestCenter doURLRequest:_request finished:^(NSURLResponse *respnse, NSData *data) {
        NSLog(@"成功");
    } failed:^(NSURLResponse *response, NSError *error) {
        NSLog(@"失败");
    }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
