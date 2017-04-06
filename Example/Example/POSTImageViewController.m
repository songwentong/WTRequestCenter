//
//  POSTImageViewController.m
//  WTRequestCenter
//
//  Created by SongWentong on 10/30/15.
//  Copyright © 2015 song. All rights reserved.
//

#import "POSTImageViewController.h"
@import WTKit;
@interface POSTImageViewController ()
{
    BOOL _sending;
}
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation POSTImageViewController


/*!
    注意:
    这段代码和ImageReceiveServer.py 配合使用
    ImageReceiveServer.py在本文件所在的文件夹中.
 
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _statusLabel.text = @"点击图片来发送";
    
   
}
- (IBAction)send:(id)sender {
    if (_sending) {
        
    }else{
        _sending = YES;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        
        
        //对应的文件(图片,视频)的数据
        UIImage *image = [UIImage imageNamed:@"image"];
        NSData *data1 = UIImageJPEGRepresentation(image, 1.0);
        
        //    文件数据
        [dict setValue:data1 forKey:@"content"];
        //    服务端接收的key
        [dict setValue:@"fileContents" forKey:@"name"];
        //    文件名(可不填)
        [dict setValue:@"image.png" forKey:@"filename"];
        //    文件类型(可不填)
        [dict setValue:@"image/png" forKey:@"contentType"];
        
        NSURLRequest *request = [[WTNetWorkManager sharedKit] POSTRequestWithURL:@"http://localhost:9000/cgi-bin/PostIt.py" parameters:nil body:@[dict]];
        
        
        _statusLabel.text = @"发送中";
        [[WTNetWorkManager sharedKit] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (s.length==0) {
                        _statusLabel.text = @"POST 成功";
                    }else{
                        _statusLabel.text = @"失败";
                    }
                }];
            }else{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    _statusLabel.text = @"失败";
                }];
            }
        }];

        
    }
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
