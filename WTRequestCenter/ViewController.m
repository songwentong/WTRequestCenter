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
#import "WTRequestViewController.h"
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
//    [self get];
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

    
//    [self testWebView];
    
    
    
    
//    [WTRequestCenter clearAllCache];
//    查看内存用量 单位是byte
//    Returns the current size of the receiver’s in-memory cache, in bytes.
//    NSLog(@"当前内存用量  %u KB",[[WTRequestCenter sharedCache] currentMemoryUsage]/1024);
    
//    查看缓存（Cache）用量,单位是byte
//    The current size of the receiver’s on-disk cache, in bytes.
//    NSLog(@"缓存用量  %@",[WTRequestCenter currentDiskUsageString]);
    [self configModel];
    [self configView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [wtTableView reloadData];
}
-(void)configModel
{
    requestTypesArray = [[NSMutableArray alloc] init];
    [requestTypesArray addObject:@"GET 请求"];
    [requestTypesArray addObject:@"POST 请求"];
}

-(void)configView
{
    
    self.title = @"WTRequestCenter";
    
    
    wtTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    wtTableView.frame = CGRectMake(0, 64, 320, [UIDevice screenHeight]-64);
    [self.view addSubview:wtTableView];
    wtTableView.dataSource = self;
    wtTableView.delegate = self;
}


-(void)testWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadWithURL:@"http://99.h5gwyx.sinaapp.com/game?gid=1" option:WTRequestCenterCachePolicyNormal];
    [self.view addSubview:webView];
}


-(void)get
{
    NSInteger count = 1;
//    __block NSInteger finish = 0;
//    __block NSInteger size = 0;
    for (int i=0; i<count; i++) {

        NSString  *url = @"http://www.sina.com.cn";
        url = @"http://www.baidu.com";
        url = @"http://www.blizzard.com";
        url = @"http://www.apple.com";
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"1928845312" forKey:@"uid"];
        [parameters setValue:@"1" forKey:@"type"];
//        [parameters setValue:@"ae7d3f36dafbb69491aadf36862f7ff8" forKey:@"sign"];
        
        
        [WTRequestCenter getWithURL:url parameters:parameters finished:^(NSURLResponse *response, NSData *data) {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",string);
        } failed:^(NSURLResponse *response, NSError *error) {
            NSLog(@"%@",response);
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

-(void)loadImage
{
    NSString *url = @"http://img0.bdstatic.com/img/image/shouye/dengni47.jpg";
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
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"aaa" withExtension:@"gif"];
    NSString *str = [[NSBundle mainBundle]pathForResource:@"aaa" ofType:@"gif"];
    [UIImage gifImageWithURL:str
                  completion:^(UIImage *image) {
                      imageView.image = image;
                  }];
    
    
}

-(void)gifButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 480/2, 320, 480/2);

    NSString *url2 = @"http://img2.duitang.com/uploads/item/201208/28/20120828224017_MZtRh.gif";
    button.contentMode = UIViewContentModeCenter;

    
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


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
        {
            numberOfRows = [requestTypesArray count];
        }
            break;
        case 1:
        {
            numberOfRows = 2;
        }
            break;
            
        default:
            break;
    }
    return numberOfRows;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                case 1:
                {
//                POST
                    NSString *text = requestTypesArray[indexPath.row];
                    cell.textLabel.text = text;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    NSString *text = [WTRequestCenter currentDiskUsageString];
                    text = [NSString stringWithFormat:@"硬盘用量:%@",text];
                    cell.textLabel.text = text;
                }
                    break;
                case 1:
                {
                    NSURLCache *cache = [WTRequestCenter sharedCache];
                    NSInteger bytes = cache.currentMemoryUsage;
                    NSString *string = [NSByteCountFormatter stringFromByteCount:bytes countStyle:NSByteCountFormatterCountStyleMemory];
                    string = [NSString stringWithFormat:@"内存用量:%@",string];
                    cell.textLabel.text = string;
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
//        GET,POST


            WTRequestViewController *vc = [[WTRequestViewController alloc] init];
            vc.indexPath = indexPath;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        case 1:
        {
//        缓存
            
        }
            break;
            
        default:
            break;
    }
    
}



@end
