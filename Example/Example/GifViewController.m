//
//  GifViewController.m
//  WTRequestCenter
//
//  Created by SongWentong on 5/5/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "GifViewController.h"
@import WTKit;
@interface GifViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation GifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"aaa@2x" ofType:@"gif"]];
    UIImage *image = [UIImage animatedImageWithAnimatedGIFData:data];
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.image = image;
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLink:)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
-(void)displayLink:(CADisplayLink *)link
{
    
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
