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
    
    switch (_indexPath.row) {
        case 0:
        {
            [self get];
        }
            break;
            case 1:
        {
            [self post];
        }break;
            
        default:
            break;
    }
    
    
}
-(void)get
{
    NSInteger count = 1;
    //    __block NSInteger finish = 0;
    //    __block NSInteger size = 0;
    for (int i=0; i<count; i++) {
        
        NSString  *url = @"http://www.sina.com.cn";
//        url = @"http://www.baidu.com";
        url = @"http://www.blizzard.com";
//        url = @"http://www.apple.com";
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"1928845312" forKey:@"uid"];
        [parameters setValue:@"1" forKey:@"type"];
        //        [parameters setValue:@"ae7d3f36dafbb69491aadf36862f7ff8" forKey:@"sign"];
        
        
        
        
        [WTRequestCenter getWithURL:url parameters:parameters option:WTRequestCenterCachePolicyCacheAndRefresh finished:^(NSURLResponse *respnse, NSData *data) {
            NSLog(@"成功");
        } failed:^(NSURLResponse *response, NSError *error) {
            NSLog(@"失败");
        }];
        
        
        
        
        
    }
    
    
    
}

-(void)testGet
{
    NSString *url = @"http://b.hiphotos.baidu.com/image/pic/item/5bafa40f4bfbfbed42c3044e7bf0f736afc31f6c.jpg";
    [WTRequestCenter testGetWithURL:url
                         parameters:nil
                             option:WTRequestCenterCachePolicyNormal
                           progress:^(NSUInteger bytesRead, long long totalBytesRead,
                                      long long totalBytesExpectedToRead)
     {
         NSString *string = [NSString stringWithFormat:@"本次数据接收量：%d,当前收到的总数据量：%lld,期望的总数据量：%lld",bytesRead,totalBytesRead,totalBytesExpectedToRead];
         NSLog(@"%@",string);
     } finished:^(NSURLResponse *respnse, NSData *data) {
         
     } failed:^(NSURLResponse *response, NSError *error) {
         
     }];
    //    for (WTURLRequestOperation *operation in [WTRequestCenter sharedQueue].operations) {
    //        [operation cancel];
    //    }
    //    NSLog(@"%@",[WTRequestCenter sharedQueue].operations);
}

-(void)post
{
    
    NSString *url = [WTRequestCenter urlWithIndex:0];
    url = @"http://s01.meiriq.com/gamesbox/public/index.php/user/add-fav";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"5406906dcb02be7d279d26f9" forKey:@"gid"];
    [parameters setValue:@"ae7d3f36dafbb69491aadf36862f7ff8" forKey:@"sign"];
    [parameters setValue:@"1" forKey:@"type"];
    [parameters setValue:@"1928845312" forKey:@"uid"];
    //    username=xuefenjuan&device_id=C40DAED0-1153-4E79-BD87-D241CCA46DC1&password=111111
    /*
     [WTRequestCenter postWithURL:url parameters:parameters finished:^(NSURLResponse *response, NSData *data) {
     NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSLog(@"%@",string);
     } failed:^(NSURLResponse *response, NSError *error) {
     NSLog(@"xx");
     }];
     */
    [WTRequestCenter postWithURL:url
                      parameters:parameters
                          option:WTRequestCenterCachePolicyCacheElseWeb
                        finished:^(NSURLResponse *respnse, NSData *data) {
                            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            NSLog(@"%@",string);
                        }failed:^(NSURLResponse *response, NSError *error) {
                            NSLog(@"xx");
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
