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
    NSURL *imageURL = [NSURL URLWithString:[@"http://img0.bdstatic.com/img/image/百度0529.jpg" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageView];
    [WTRequestCenter getImageWithURL:imageURL imageComplectionHandler:^(UIImage *image) {
        imageView.image = image;
        
    }];
    
    
    
    
//    缓存用量
    NSUInteger usage = [WTRequestCenter currentDiskUsage];
    NSLog(@"%u",usage);
    
//    -------post request--------
    return;
    for (int i=0; i<10; i++) {
        
        [WTRequestCenter getWithURL:url
                  completionHandler:^(NSURLResponse *response, NSData *data) {
                      NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                      NSLog(@"%@",string);
                  }];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"1" forKey:@"a"];
        [dict setValue:@"2" forKey:@"b"];
        [dict setValue:@"3" forKey:@"c"];
        [WTRequestCenter postWithURL:url params:dict completionHandler:^(NSURLResponse *response, NSData *data) {
            
        }];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
