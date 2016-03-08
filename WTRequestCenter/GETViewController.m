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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestPressed:(id)sender
{
    NSError *error = nil;
    NSURLRequest *request =  [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:_urlTextField.text parameters:nil error:&error];
    if (error) {
//        UIAlertController *ac = [[UIAlertController alloc] init];
//        ac.title =
//        [self presentview]
    }else{
        [[WTNetWorkManager sharedKit] taskWithRequest:request finished:^(NSData *data, NSURLResponse *response) {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (string) {
                _textView.text = string;
            }
        } failed:^(NSError *error) {
            
        }];
    }
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
