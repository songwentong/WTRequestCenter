//
//  HomeViewController.m
//  WTRequestCenter
//
//  Created by SongWentong on 10/29/15.
//  Copyright © 2015 song. All rights reserved.
//

#import "HomeViewController.h"
#import "WTKit.h"
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

    
    
//    NSMutableArray *array = [NSMutableArray new];
//    [array appendObjects:@"%@%@",@"a",@"b"];
//    NSLog(@"%@",array);

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 4;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

-(NSString*)titleForIndexPath:(NSIndexPath*)indexPath
{
    NSString *string = @"";
    NSMutableArray *array = [NSMutableArray array];
    
    //section1
    NSMutableArray *section1 = [NSMutableArray array];
    [section1 addObject:@"GET 请求"];
    [section1 addObject:@"POST 请求"];
    [section1 addObject:@"image 缓存"];
    [section1 addObject:@"image 上传"];
    [array addObject:section1];
    
    //section2
    NSMutableArray *section2 = [NSMutableArray array];
    [section2 addObject:@"UIAlertController"];
    [array addObject:section2];
    
    
    
    string = array[indexPath.section][indexPath.row];
    return string;
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
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *string = @"";
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:@[@"网络请求",@"UI"]];
    string = array[section];
    
    return string;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self titleForIndexPath:indexPath];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        [self performSegueWithIdentifier:[self segueWithIndexPath:indexPath] sender:nil];
    }else{
        UIAlertController *con = [UIAlertController alertControllerWithTitle:@"alert" message:@"msg" preferredStyle:UIAlertControllerStyleAlert];
        [con addAction:[UIAlertAction actionWithTitle:@"UIAlertActionStyleDefault" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [con addAction:[UIAlertAction actionWithTitle:@"UIAlertActionStyleCancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [con addAction:[UIAlertAction actionWithTitle:@"UIAlertActionStyleDestructive" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:con animated:YES completion:^{
            
        }];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

@end
