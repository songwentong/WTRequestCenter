//
//  WTRequestViewController.m
//  WTRequestCenter
//
//  Created by SongWentong on 14-10-15.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTRequestViewController.h"
#import "WTRequestCenter.h"
#import "UIKit+WTRequestCenter.h"
@interface WTRequestViewController () <WTNetworkHUDDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *logScrollView;

@property (weak, nonatomic) IBOutlet UILabel *logLabel;
@end

@implementation WTRequestViewController

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
    
//    [self initHUD];
//    [self wtActiveIndicatorView].delegate = self;
//    [self.wtActiveIndicatorView startAnimating];
    
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


    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"http://www.sina.com.cn"];
    [array addObject:@"http://www.blizzard.com"];
    [array addObject:@"http://www.apple.com/cn"];
    [array addObject:@"http://www.baidu.com"];
    [array addObject:@"http://www.cocoachina.com"];
    [array addObject:@"http://www.taobao.com"];
    [array addObject:@"http://www.tmall.com"];
    [array addObject:@"https://developer.apple.com/library/ios/navigation"];
    [array addObject:@"https://github.com"];
    [array addObject:@"http://www.w3school.com.cn"];
    [array addObject:@"https://developer.apple.com"];
    [array addObject:@"http://image.baidu.com"];
    [array addObject:@"http://image.baidu.com/channel/star/杨幂"];
    [array addObject:@"http://image.baidu.com/channel/star/范冰冰"];
    [array addObject:@"http://image.baidu.com/channel/star/林志玲"];
    [array addObject:@"http://image.baidu.com/channel/star/柳岩"];
    
    
    __block NSInteger finishCount = 0;
    
    [array enumerateObjectsUsingBlock:^(NSString *url, NSUInteger idx, BOOL *stop) {
        
//        [self appendLogString:[NSString stringWithFormat:@"request start :%@",url]];
        [WTRequestCenter getWithURL:url parameters:nil option:WTRequestCenterCachePolicyNormal finished:^(NSURLResponse *response, NSData *data) {
            finishCount = finishCount + 1;
            if (finishCount == [array count]) {
//                [self stopLoadWTHud];
            }
//            NSLog(@"------finished %@",response.URL);
        [self appendLogString:[NSString stringWithFormat:@"request finished :%@",url]];
        } failed:^(NSURLResponse *response, NSError *error) {
//            NSLog(@"failed:%@",response.URL);
            
//            NSLog(@"------failed %@",response.URL);
            
            finishCount = finishCount + 1;
            if (finishCount == [array count]) {
//                [self stopLoadWTHud];
            }
        }];
        
//        NSCachedURLResponse *res = [[WTRequestCenter sharedCache] cachedResponseForRequest:request];
//        NSTimeInterval time = [[res.userInfo valueForKey:@"responseTime"] floatValue];
//        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
//        NSLog(@"responseTime:%@",date);
//        NSLog(@"userInfo :%@",res.userInfo);
    }];
    

    
}

-(void)appendLogString:(NSString*)string
{
    NSString *string2 = [NSString stringWithFormat:@"%@\n%@",_logLabel.text,string];
    _logLabel.text = string2;
//    _logLabel.userInteractionEnabled = NO;
    /*
    _logScrollView.contentSize = [_logLabel.attributedText boundingRectWithSize:_logLabel.frame.size
                                                                       options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                       context:nil].size;
     */
//    _logScrollView.scrollEnabled = YES;
    
//    NSLog(@"%@",string2);
}


-(void)post
{
    
    NSString *url = nil;
    url = @"http://xxx.com";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];


    [WTRequestCenter postWithURL:url
                      parameters:parameters
                        finished:^(NSURLResponse *response, NSData *data) {
                        }failed:^(NSURLResponse *response, NSError *error) {
//                            NSLog(@"xx");
                        }];
    
    
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

#pragma mark - WTNetworkHUDDelegate
-(UIImage*)wtNetWorkHUDImage:(WTNetworkHUD*)hud
{
    return [UIImage imageNamed:@"SampleImage"];
}


@end
