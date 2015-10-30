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
    
    
    
    //对应的文件(图片,视频)的数据
    UIImage *image = [UIImage imageNamed:@"image.jpg"];
    NSData *data1 = UIImageJPEGRepresentation(image, 1.0);
    
//    文件数据
    [dict setValue:data1 forKey:@"content"];
//    服务端接收的key
    [dict setValue:@"name" forKey:@"name"];
//    文件名(可不填)
    [dict setValue:@"filename" forKey:@"filename"];
//    文件类型(可不填)
    [dict setValue:@"image/jpeg" forKey:@"contentType"];
    
    NSURLRequest *request = [[WTNetWorkManager sharedKit] POSTRequestWithURL:@"http://127.0.0.1:9000/" parameters:nil body:@[dict]];
    [[[WTNetWorkManager sharedKit].session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }else{
            NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",s);
        }
        
    }] resume];
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
