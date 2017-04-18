//
//  WebImageViewController.m
//  Example
//
//  Created by SongWentong on 18/04/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

#import "WebImageViewController.h"
@import WTKit;
@interface WebImageViewController ()

@end

@implementation WebImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ////"https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage001"
    int index = (int)indexPath.row;
    NSString *imageURL = [NSString stringWithFormat:@"https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage%03d.jpg",index];
    UIImageView *imageView = [cell.contentView viewWithTag:1];
    [imageView setImageWithURL:imageURL];
    UILabel *label = [cell.contentView viewWithTag:2];
    label.text = [NSString stringWithFormat:@"#%ld",indexPath.row];
    return cell;
}

@end
