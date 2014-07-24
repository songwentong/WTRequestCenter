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
    
    UIImage *image = [UIImage imageWithData:nil];
    NSLog(@"%@",image);
    
//    GET请求
    [self get];
//    POST请求
    [self post];
    
}



-(void)get
{
    NSURL *url = [NSURL URLWithString:[WTRequestCenter urlWithIndex:0]];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"1" forKey:@"a"];
    [parameters setValue:@"2" forKey:@"b"];
    [parameters setValue:@"3" forKey:@"c"];
    
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
    NSURL *url = [NSURL URLWithString:@"http://www.xxx.com/eqdsa.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [WTRequestCenter getImageWithURL:url imageComplectionHandler:^(UIImage *image) {
        imageView.image = image;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
