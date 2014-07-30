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
    
//    UIImage *image = [UIImage imageWithData:nil];
//    NSLog(@"%@",image);
    NSLog(@"%@",[[NSProcessInfo processInfo] globallyUniqueString]);
//    GET请求
//    [self get];
//    POST请求
//    [self post];
    [self loadImage];
    
}



-(void)get
{
    NSURL *url = [NSURL URLWithString:[WTRequestCenter urlWithIndex:0]];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"46" forKey:@"article_id"];
//    [parameters setValue:@"2" forKey:@"b"];
//    [parameters setValue:@"3" forKey:@"c"];
//    article_id=46
    [WTRequestCenter getWithURL:url
                     parameters:parameters
              completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                          if (!error) {
                              NSError *jsonError = nil;
                              id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                              if (!jsonError) {
                                  NSLog(@"result:%@",obj);
                              }else
                              {
                                  NSLog(@"jsonError:%@",jsonError);
                              }
                              
                          }else
                          {
                              NSLog(@"error:%@",error);
                          }
                  
                      }];
//    [WTRequestCenter stopAllRequest];
}

-(void)post
{
    NSURL *url = [NSURL URLWithString:[WTRequestCenter urlWithIndex:0]];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"1" forKey:@"a"];
    [parameters setValue:@"2" forKey:@"b"];
    [parameters setValue:@"3" forKey:@"c"];
    [WTRequestCenter postWithURL:url
                      parameters:parameters completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                          if (!error) {
                              NSError *jsonError = nil;
                              id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                              if (!jsonError) {
                                  NSLog(@"result:%@",obj);
                              }else
                              {
                                  NSLog(@"jsonError:%@",jsonError);
                              }
                              
                          }else
                          {
                              NSLog(@"error:%@",error);
                          }
                          
                      }];
}

-(void)loadImage
{
    NSURL *url = [NSURL URLWithString:@"http://img02.v1pin.com/photo/201407/201407089004037836461.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.frame = CGRectMake(0, 0, 200, 200);
    UIImage *placeHolderImage = [UIImage imageNamed:@"xxx.png"];
    [imageView setImageWithURL:url placeholderImage:placeHolderImage];
    
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
