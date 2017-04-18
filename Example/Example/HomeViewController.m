//
//  HomeViewController.m
//  WTRequestCenter
//
//  Created by SongWentong on 10/29/15.
//  Copyright © 2015 song. All rights reserved.
//

#import "HomeViewController.h"
@import WTKit;
@import AVFoundation;
#import "GETViewController.h"
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
    
    
    
//    WTLog(@"asdas");
    
    

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




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destinationViewController = segue.destinationViewController;
    if ([destinationViewController isKindOfClass:[GETViewController class]]) {
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        GETViewController *get = (GETViewController*)destinationViewController;
        get.demoIndex = indexPath.row;
        
    }
}

//imageView

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
            return 2;
        }
            break;
        case 2:
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
    [section1 addObject:@"GET Request"];
    [section1 addObject:@"POST Request"];
    [section1 addObject:@"PUT Request"];
    [section1 addObject:@"DELETE Request"];
    [array addObject:section1];
    
    //section2
    NSMutableArray *section2 = [NSMutableArray array];
    [section2 addObject:@"Web Image"];
    [section2 addObject:@"Gif"];
    [array addObject:section2];
    [array addObject:@[@"JSONModel"]];
    
    
    string = array[indexPath.section][indexPath.row];
    return string;
}

-(NSString*)segueWithIndexPath:(NSIndexPath*)indexPath
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"get"];
    [array addObject:@"get"];
    [array addObject:@"get"];
    [array addObject:@"get"];
    return array[indexPath.row];
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *string = @"";
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:@[@"网络请求",@"UI",@"JSON Model"]];
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
    switch (indexPath.section) {
        case 0:
        {
            [self performSegueWithIdentifier:@"get" sender:indexPath];
//            [self performSegueWithIdentifier:[self segueWithIndexPath:indexPath] sender:indexPath];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self performSegueWithIdentifier:@"webImage" sender:nil];
                }
                    break;
                case 1:
                {
                [self performSegueWithIdentifier:@"gif" sender:nil];
                }
                    break;
                    
                default:
                    break;
            }
            //gif
            
        }
            break;
        case 2:
        {
            [self performSegueWithIdentifier:@"jsonModelDemo" sender:nil];
        }
            break;
            
        default:
            break;
    }
    /*
    if (indexPath.section==0) {
        
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
     */
    
}

@end
