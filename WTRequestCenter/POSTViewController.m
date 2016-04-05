//
//  POSTViewController.m
//  WTRequestCenter
//
//  Created by SongWentong on 1/29/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "POSTViewController.h"
#import "ParametersVC.h"
#import "WTKit.h"
@interface POSTViewController () <ParametersVCDelegate>
{
//    UISegmentedControl *_segment;
}
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (nonatomic,strong) NSMutableArray *parameters;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;

@end

@implementation POSTViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.parameters = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _segment = [[UISegmentedControl alloc] initWithItems:@[@"请求",@"参数"]];
//    self.navigationItem.titleView = _segment;
}

- (IBAction)request:(id)sender {
    NSString *url = _urlTextField.text;
    if (![url hasPrefix:@"http://"]) {
        url = [NSString stringWithFormat:@"http://%@",url];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [_parameters enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [parameters setDictionary:dict];
    }];
    NSURLRequest *request =  [[WTNetWorkManager sharedKit] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    [[WTNetWorkManager sharedKit] taskWithRequest:request finished:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (string) {
            _resultTextView.text = string;
        }else{
            _resultTextView.text = @"请求成功,结果无法以文字形式展示";
        }
        
        
    } failed:^(NSError * _Nonnull error) {
        _resultTextView.text = [NSString stringWithFormat:@"请求失败:%@",error.localizedDescription];
    }];
}

- (IBAction)configParas:(id)sender {
    [self performSegueWithIdentifier:@"parameters" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *dest = segue.destinationViewController;
    if ([dest isKindOfClass:[ParametersVC class]]) {
        ParametersVC *temp = (ParametersVC*)dest;
        temp.parameters = self.parameters;
        temp.delegate = self;
    }
}
#pragma mark - ParametersVCDelegate
-(void)parametersVCGetParameters:(ParametersVC*)vc
{
    self.parameters = vc.parameters;
}


@end
