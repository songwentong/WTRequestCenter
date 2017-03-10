//
//  ParametersVC.m
//  WTRequestCenter
//
//  Created by SongWentong on 4/5/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "ParametersVC.h"

@interface ParametersVC ()
{
    
}
@end

@implementation ParametersVC
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}
- (IBAction)commitParameters:(id)sender {
    [self.delegate parametersVCGetParameters:self];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)clearParameters:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)savePressed:(UIButton*)sender{
    UITableViewCell *cell = (UITableViewCell*)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    UITextField *tf1 = [cell viewWithTag:1];
    UITextField *tf2 = [cell viewWithTag:2];
    NSDictionary *dict = @{tf1.text:tf2.text};
    if (indexPath.row==_parameters.count) {
        [_parameters addObject:dict];
    }else{
        [_parameters replaceObjectAtIndex:indexPath.row withObject:dict];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _parameters.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITextField *tf1 = [cell viewWithTag:1];
    UITextField *tf2 = [cell viewWithTag:2];
    UIButton *button = [cell viewWithTag:3];
    
    [button addTarget:self action:@selector(savePressed:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row<_parameters.count) {
        NSDictionary *dict = _parameters[indexPath.row];
        NSString *key = [[dict allKeys] lastObject];
        tf1.text = key;
        tf2.text = [dict valueForKey:key];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
