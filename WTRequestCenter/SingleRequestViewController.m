//
//  SingleRequestViewController.m
//  WTRequestCenter
//
//  Created by SongWentong on 15/2/13.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "SingleRequestViewController.h"
#import "UIKit+WTRequestCenter.h"

@interface SingleRequestViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_requestArray;
    
    NSMutableArray *_urlArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SingleRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _requestArray = [[NSMutableArray alloc] init];
    _urlArray = [[NSMutableArray alloc] init];
    
    [_requestArray addObject:@"百度"];
    [_requestArray addObject:@"新浪"];
    [_requestArray addObject:@"w3c"];
    [_requestArray addObject:@"developer"];
    
    
    [_urlArray addObject:@"http://www.baidu.com"];
    [_urlArray addObject:@"http://www.sina.com.cn"];
    [_urlArray addObject:@"http://www.w3school.com.cn"];
    [_urlArray addObject:@"https://developer.apple.com"];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_urlArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [UITableViewCell new];
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",_requestArray[indexPath.row],_urlArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [WTRequestCenter getWithURL:_urlArray[indexPath.row]
                     parameters:nil
                       finished:^(NSURLResponse *response, NSData *data) {
                           NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功"
                                                                           message:message
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"确定"
                                                                 otherButtonTitles:nil];
                           [alert show];
                           
                           
                       } failed:^(NSURLResponse *response, NSError *error) {
                           NSString *msg = error.localizedDescription;
                           [UIAlertView showAlertWithMessage:msg];
                       }];
}
@end
