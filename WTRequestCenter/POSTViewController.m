//
//  POSTViewController.m
//  WTRequestCenter
//
//  Created by SongWentong on 1/29/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "POSTViewController.h"

@interface POSTViewController ()
{
//    UISegmentedControl *_segment;
}
@end

@implementation POSTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _segment = [[UISegmentedControl alloc] initWithItems:@[@"请求",@"参数"]];
//    self.navigationItem.titleView = _segment;
}
- (IBAction)setParameters:(id)sender {
    [self performSegueWithIdentifier:@"parameters" sender:nil];
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
