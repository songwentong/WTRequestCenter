//
//  POSTImageViewController.m
//  WTRequestCenter
//
//  Created by SongWentong on 10/30/15.
//  Copyright © 2015 song. All rights reserved.
//

#import "POSTImageViewController.h"
#import "WTNetWork.h"
@interface POSTImageViewController ()

@end

@implementation POSTImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[@"content" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"content"];
    [dict setValue:@"name" forKey:@"name"];
    [dict setValue:@"filename" forKey:@"filename"];
    NSURLRequest *request = [[WTNetWorkManager sharedKit] POSTRequestWithURL:@"das" parameters:nil body:@[dict]];
    [[WTNetWorkManager sharedKit].session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
