//
//  ViewController.m
//  WTRequestCenter
//
//  Created by song on 14-7-19.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "ViewController.h"
#import "WTRequestCenter.h"
#import "UIKit+WTRequestCenter.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//  设置响应失效日期
//    NSLog(@"%f",[WTRequestCenter expireTimeInterval]);
//    [WTRequestCenter setExpireTimeInterval:0];
    NSLog(@"%@",NSHomeDirectory());
    
//    NSLog(@"uuid:%@",[UIDevice WTUUID]);
    
//    NSLog(@"%@",[NSBundle mainBundle].executableArchitectures);
    
//    GET请求
    [self get];
//    [self testGet];
    
//    POST请求
//    [self post];
//    下载图片
//    [self loadImage];
//    [WTRequestCenter cancelAllRequest];
//    gif
//    [self loadGif];
    
//    [self gifButton];

//    存取数据
//    [self saveAndWrite];

    
    
    
    
//    [WTRequestCenter clearAllCache];
//    查看内存用量 单位是byte
//    Returns the current size of the receiver’s in-memory cache, in bytes.
//    NSLog(@"当前内存用量  %u KB",[[WTRequestCenter sharedCache] currentMemoryUsage]/1024);
    
//    查看缓存（Cache）用量,单位是byte
//    The current size of the receiver’s on-disk cache, in bytes.
//    NSLog(@"缓存用量  %u KB",[WTRequestCenter currentDiskUsage]/1024);
}



-(void)get
{
    NSInteger count = 1;
//    __block NSInteger finish = 0;
//    __block NSInteger size = 0;
    for (int i=0; i<count; i++) {

        NSURL *url = [NSURL URLWithString:@"http://www.sina.com.cn"];
        url = [NSURL URLWithString:@"http://www.baidu.com"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//        [parameters setValue:@"1928845312" forKey:@"uid"];
//        [parameters setValue:@"1" forKey:@"type"];
//        [parameters setValue:@"ae7d3f36dafbb69491aadf36862f7ff8" forKey:@"sign"];
        
        
        [WTRequestCenter getWithURL:url parameters:parameters finish:^(NSURLResponse *response, NSData *data) {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",string);
        } failure:^(NSURLResponse *response, NSError *error) {
            NSLog(@"%@",response);
        }];
        
        /*
        [WTRequestCenter getCacheWithURL:url parameters:parameters finish:^(NSURLResponse *response, NSData *data) {
            NSLog(@"%@",response);
        } failure:^(NSURLResponse *response, NSError *error) {
            NSLog(@"%@",response);
        }];
         */

    }

    
    
}

-(void)testGet
{
    NSURL *url = [NSURL URLWithString:@"http://www.sina.com.cn"];
    [WTRequestCenter testGetWithURL:url parameters:nil option:WTRequestCenterCachePolicyNormal completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"ok");
    }];
//    for (WTURLRequestOperation *operation in [WTRequestCenter sharedQueue].operations) {
//        [operation cancel];
//    }
//    NSLog(@"%@",[WTRequestCenter sharedQueue].operations);
}

-(void)post
{
    NSURL *url = [NSURL URLWithString:[WTRequestCenter urlWithIndex:0]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"1" forKey:@"a"];
    [parameters setValue:@"2" forKey:@"b"];
    [parameters setValue:@"3" forKey:@"c"];
    
    
    [WTRequestCenter postWithURL:url parameters:parameters finish:^(NSURLResponse *response, NSData *data) {
        
    } failure:^(NSURLResponse *response, NSError *error) {
        
    }];
}

-(void)loadImage
{
    NSURL *url = [NSURL URLWithString:@"http://img0.bdstatic.com/img/image/shouye/dengni47.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.frame = self.view.bounds;
    imageView.frame = CGRectMake(0, 64, 320, 480/2);
    UIImage *placeHolderImage = [UIImage imageNamed:@"image.jpg"];
    [imageView setImageWithURL:url placeholderImage:placeHolderImage];
    
    [self.view addSubview:imageView];
}

-(void)loadGif
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.frame = CGRectMake(0, 480/2, 320, 480/2);
    imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageView];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"aaa" withExtension:@"gif"];
    [UIImage gifImageWithURL:url
                  completion:^(UIImage *image) {
                      imageView.image = image;
                  }];
    
    
}

-(void)gifButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 480/2, 320, 480/2);
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"aaa@2x" withExtension:@"gif"];
    NSURL *url2 = [NSURL URLWithString:@"http://img2.duitang.com/uploads/item/201208/28/20120828224017_MZtRh.gif"];
    button.contentMode = UIViewContentModeCenter;
//    [button setImage:[UIImage animatedImageWithAnimatedGIFURL:url2] forState:UIControlStateNormal];
    
    [UIImage gifImageWithURL:url2
                  completion:^(UIImage *image) {
                      [button setImage:image forState:UIControlStateNormal];
                  }];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)button:(UIButton*)sender
{
    NSLog(@"pressed");
}

-(void)saveAndWrite
{
    
    [WTDataSaver saveData:[@"hello world" dataUsingEncoding:NSUTF8StringEncoding] withIndex:2 completion:^{
        NSLog(@"finished");
    }];
    
    [WTDataSaver dataWithIndex:2 completion:^(NSData *data) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",string);
    }];
    /*
    [WTDataSaver dataWithIndex:2 completion:^(NSData *data) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",string);
    }];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
