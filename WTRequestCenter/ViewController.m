//
//  ViewController.m
//  WTRequestCenter
//
//  Created by song on 14-7-19.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "ViewController.h"
#import "WTRequestCenter.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    
    for (int i=0; i<10; i++) {
        [WTRequestCenter getWithURL:url
                  completionHandler:^(NSURLResponse *response, NSData *data) {
                      NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                      NSLog(@"%@",string);
                  }];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
