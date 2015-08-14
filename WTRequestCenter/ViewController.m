//
//  ViewController.m
//  WTRequestCenter
//
//  Created by song on 14-7-19.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "ViewController.h"
#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
#import "RulerView.h"

#import "SingleRequestViewController.h"
#import "WTRequestViewController.h"
#import "WTWebViewController.h"
#import "WTImageViewController.h"
//static const NSTimeInterval kAnimationTime = 0.3f;

@interface ViewController ()
{
    UIImageView *imageView;
    RulerView *_relerView;
    NSInteger requestCount;
}
@end

@implementation ViewController


-(void)loadimage
{
    [imageView setImageWithURL:@"http://i2.sinaimg.cn/home/2014/1204/U6604P30DT20141204094533.jpg" placeholderImage:[UIImage imageNamed:@"aaa"] finished:^(NSURLResponse *response, NSData *data) {
        
    } failed:^(NSURLResponse *response, NSError *error) {
        
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];


    [self configModel];
    [self configView];
    

    
    
  
    _relerView = [[RulerView alloc] initWithFrame:self.view.bounds];
    _relerView.userInteractionEnabled = NO;
    [self.view addSubview:_relerView];
    
    /*
    [[WTRequestCenter sharedQueue] addOperationWithBlock:^{
        NSString *name = [NSOperationQueue currentQueue].name;
        NSLog(@"%@",name);
        NSLog(@"1");
        [WTRequestCenter performBlock:^{
            NSLog(@"2");
        } inQueue:[WTRequestCenter sharedQueue].underlyingQueue
                           afterDelay:3.0];
    }];
     */
    
    [WTRequestCenter GETUsingCache:@"http://www.baidu.com"
                        parameters:nil
                          finished:^(NSURLResponse *response, NSData *data) {
//                              NSLog(@"%@",data);
                          } failed:^(NSURLResponse *response, NSError *error) {
                              
                          }];
    
    
}


-(void)takeSnapShot
{
    UIGraphicsBeginImageContext(self.view.bounds.size);

//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//    BOOL finish = [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    if (finish) {
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//    }
    UIGraphicsEndImageContext();
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [wtTableView reloadData];
    [_relerView setNeedsLayout];

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}



-(void)configModel
{
    requestTypesArray = [[NSMutableArray alloc] init];
    [requestTypesArray addObject:@"GET 请求"];
    [requestTypesArray addObject:@"单发请求"];
    [requestTypesArray addObject:@"图片请求"];
}

-(void)configView
{
    
    self.title = @"WTRequestCenter";
    
    
    wtTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    wtTableView.frame = CGRectMake(40, 0, 320-40, [UIScreen screenHeight]-64);
    [self.view addSubview:wtTableView];
    wtTableView.dataSource = self;
    wtTableView.delegate = self;
    
    
    UIImageView *temp = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen screenWidth]-100, [UIScreen screenHeight]-100, 100, 100)];
    [self.view addSubview:temp];
    [temp setImageWithURL:@"http://d.hiphotos.baidu.com/image/pic/item/d53f8794a4c27d1e01c0f3d919d5ad6edcc438cd.jpg"];
    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"clear"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(clearAll:)];
}

-(void)clearAll:(id)sender
{
    [[WTRequestCenter sharedCache] removeAllCachedResponses];
    [wtTableView reloadData];
    
    [UIAlertView showAlertWithTitle:@"alert"
                            message:@"cache removed"
                           duration:2];
}


-(void)testWebView
{

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
//            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",string);
        } failed:^(NSURLResponse *response, NSError *error) {
//            NSLog(@"%@",response);
        }];
        
        
        
        
        

    }

    
    
}

-(void)post
{
    
    NSString *url = @"";
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
                        finished:^(NSURLResponse *response, NSData *data) {
//        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",string);
    }failed:^(NSURLResponse *response, NSError *error) {
//        NSLog(@"xx");
    }];
    

}
/*
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
 */

-(void)loadGif
{
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:self.view.bounds];
    image1.frame = CGRectMake(0, 480/2, 320, 480/2);
    image1.contentMode = UIViewContentModeCenter;
    [self.view addSubview:image1];
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"aaa" withExtension:@"gif"];
    NSString *str = [[NSBundle mainBundle]pathForResource:@"aaa" ofType:@"gif"];
    [UIImage gifImageWithURL:str
                  completion:^(UIImage *image) {
                    image1.image = image;
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
//        NSLog(@"finished");
    }];
    
    [WTDataSaver dataWithIndex:2 completion:^(NSData *data) {
//        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",string);
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

                    NSString *text = requestTypesArray[indexPath.row];
                    cell.textLabel.text = text;
                }
                    break;
                case 2:
                {
                    if (!imageCell)
                    {
                        imageCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
                        NSMutableArray *urls = [[NSMutableArray alloc] init];
                        [urls addObject:@"http://d.hiphotos.baidu.com/image/pic/item/d53f8794a4c27d1e01c0f3d919d5ad6edcc438cd.jpg"];
                        [urls addObject:@"http://e.hiphotos.baidu.com/image/pic/item/0e2442a7d933c89555c6c97ad31373f082020072.jpg"];
                        WTImageViewer *viewer = [[ WTImageViewer alloc] initWithFrame:CGRectMake(0, 0, 320, 100) urls:urls];
                        viewer.userInteractionEnabled = NO;
                        [imageCell.contentView addSubview:viewer];

                    }
                    imageCell.clipsToBounds = YES;
                    return imageCell;
                }
                    
                default:
                {
                    NSString *text = requestTypesArray[indexPath.row];
                    cell.textLabel.text = text;
                }
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    if (indexPath.section==0 && indexPath.row==3) {
        height = 100;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
//        GET,POST

            switch (indexPath.row) {
                case 0:
                {
                    WTRequestViewController *vc = [[WTRequestViewController alloc] init];
                    vc.indexPath = indexPath;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    case 1:
                {
                    SingleRequestViewController *vc = [[SingleRequestViewController alloc] init];
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                }
                    break;
                    case 2:
                {
//                    图片
                    WTImageViewController *vc = [[WTImageViewController alloc] init];
//                    http://t12.baidu.com/it/u=2403332987,2157329891,395,216,1,95,1,13769865750573159671&fm=89
//                    http://img0.bdstatic.com/img/image/shouye/sygjdl-9556401172.jpg
                    vc.transitioningDelegate = self;
                    NSMutableArray *urls = [[NSMutableArray alloc] init];
                    [urls addObject:@"http://d.hiphotos.baidu.com/image/pic/item/d53f8794a4c27d1e01c0f3d919d5ad6edcc438cd.jpg"];
                    [urls addObject:@"http://e.hiphotos.baidu.com/image/pic/item/0e2442a7d933c89555c6c97ad31373f082020072.jpg"];
                    vc.imageUrls = urls;
                    [self presentViewController:vc animated:YES completion:^{
                        
                    }];
                    
                }break;
                    
                default:
                    break;
            }
            
            
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


#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.5;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromVC.view;
    [containerView addSubview:fromView];
    
    
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    
    if ([toVC isKindOfClass:[WTImageViewController class]]) {
//    present
        [containerView addSubview:toView];
        CGRect frame = [wtTableView convertRect:imageCell.frame toView:containerView];
//        frame = CGRectMake(100, 300, 100, 100);
        toView.frame = frame;
        toView.clipsToBounds = YES;
        
        [UIView animateWithDuration:1.5 delay:0 options:0 animations:^{
            toView.frame = CGRectMake(0, 0, 320, 568);
        } completion:^(BOOL finished) {
            if (finished) {
                [transitionContext completeTransition:finished];
            }
            
        }];
    }else
    {
//    dismiss
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
        CGRect frame = [wtTableView convertRect:imageCell.frame toView:containerView];
        [UIView animateWithDuration:1.5 delay:0 options:0 animations:^{
            fromView.frame = frame;
        } completion:^(BOOL finished) {
            
            if (finished) {
                fromView.hidden = YES;
                [transitionContext completeTransition:finished];
            }
        }];
        
    }
    
    
    
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

@end
