//
//  WTWebViewController.m
//  WTRequestCenter
//
//  Created by song on 14-10-15.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTWebViewController.h"
#import "UIKit+WTRequestCenter.h"
@interface WTWebViewController ()

@end

@implementation WTWebViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    UIWebView *webView=  [[UIWebView alloc] initWithFrame:self.view.bounds];
    
//    [webView loadWithURL:@"http://image.baidu.com/channel/star/林志玲" option:WTRequestCenterCachePolicyCacheAndWeb];
    NSURL *url = [NSURL URLWithString:@"http://www.jd.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request option:WTRequestCenterCachePolicyNormal];
    [self.view addSubview:webView];

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
