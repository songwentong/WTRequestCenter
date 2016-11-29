//
//  GETViewController.m
//  WTRequestCenter
//
//  Created by SongWentong on 1/29/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "GETViewController.h"
#import "WTKit.h"
@interface GETViewController ()

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation GETViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _urlTextField.text = @"http://www.baidu.com";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestPressed:(id)sender
{
    NSString *url = _urlTextField.text;
    [_urlTextField resignFirstResponder];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    WTURLSessionTask *task = [[WTNetWorkManager sharedKit] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (string) {
            _textView.text = string;
        }
    }];
    [task resume];
    /*
    [[WTNetWorkManager sharedKit] taskWithWithMethod:@"GET" URLString:url parameters:nil finished:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response) {
     
    } failed:^(NSError * _Nonnull error) {
        _textView.text = [NSString stringWithFormat:@"请求失败:%@",error.localizedDescription];
    }];
     */
    

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
