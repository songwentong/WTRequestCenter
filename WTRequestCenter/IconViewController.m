//
//  IconViewController.m
//  WTRequestCenter
//
//  Created by SongWentong on 5/5/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "IconViewController.h"
#import "WTKit.h"
@import MessageUI;
@interface IconViewController ()<MFMailComposeViewControllerDelegate>
//图标的View
@property (weak, nonatomic) IBOutlet UIView *iconView;

@end

@implementation IconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)sendIcon:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        UIImage *image = [_iconView snapshot];
        MFMailComposeViewController *mailVC = [MFMailComposeViewController new];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterFullStyle];
        NSString *subject = [formatter stringFromDate:date];
        [mailVC setSubject:subject];
        [mailVC setToRecipients:@[@"275712575@qq.com"]];
        [mailVC setMessageBody:subject isHTML:NO];
        NSData *data =  UIImageJPEGRepresentation(image, 1.0);
        data = UIImagePNGRepresentation(image);
        [mailVC addAttachmentData:data mimeType:@"image/png" fileName:@"photo.png"];
        mailVC.mailComposeDelegate = self;
        [self presentViewController:mailVC animated:YES completion:^{
            
        }];
    }else{
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
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
