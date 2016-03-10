//
//  HomeViewController.m
//  WTRequestCenter
//
//  Created by SongWentong on 10/29/15.
//  Copyright © 2015 song. All rights reserved.
//

#import "HomeViewController.h"
#import "WTNetWorkManager.h"
@import AVFoundation;
@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSArray<__kindof UILayoutGuide *> *layoutGuides = self.view.layoutGuides;
//    NSLog(@"%@",layoutGuides);
//    id<UILayoutSupport> topLayoutGuide = self.topLayoutGuide;
//    NSLog(@"%@",topLayoutGuide);
    

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
//imageView

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self titles].count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

-(NSArray*)titles{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"GET 请求"];
    [array addObject:@"POST 请求"];
    [array addObject:@"image 缓存"];
    [array addObject:@"image 上传"];
    
    return array;
}

-(NSString*)segueWithIndexPath:(NSIndexPath*)indexPath
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"get"];
    [array addObject:@"post"];
    [array addObject:@"imageView"];
    [array addObject:@"postImage"];
    return array[indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self titles][indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:[self segueWithIndexPath:indexPath] sender:nil];
}

@end
