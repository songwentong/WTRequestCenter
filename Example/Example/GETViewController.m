//
//  GETViewController.m
//  WTRequestCenter
//
//  Created by SongWentong on 1/29/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "GETViewController.h"
@import WTKit;
@interface GETViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (copy) NSDictionary *allHeaderFields;
@property (copy) NSData *data;
@property (nonatomic,strong) complection_block complectionBlock;
@property (nonatomic) NSTimeInterval useTime;
@end

@implementation GETViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GET Request";
    
    self.myTableView.hidden = YES;
    __weak GETViewController* weakSelf = self;
    
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    self.complectionBlock = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //complection
        if (!error) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpRes = (NSHTTPURLResponse*)response;
                if (weakSelf != nil) {
                    weakSelf.allHeaderFields = httpRes.allHeaderFields;
                    weakSelf.data = data;
                    [weakSelf.myTableView reloadData];
                    weakSelf.myTableView.hidden = NO;
                    
                }
            }
        }else{
            
        }
        NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
        if (weakSelf != nil) {
            weakSelf.useTime = end - start;
        }
        
    };
    [self doRequestWithIndex:_demoIndex];
    
}

-(void)doRequestWithIndex:(NSInteger)index{
    NSURLRequest *request = nil;
    NSArray *titleArray = @[@"GET",@"POST",@"PUT",@"DELETE"];
    NSString *title = [NSString stringWithFormat:@"%@ https://httpbin.org/%@",titleArray[index],[titleArray[index] lowercaseString]];
    self.title = title;
    switch (index) {
        case 0:
            //get
            request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:@"https://httpbin.org/get" parameters:nil error:nil];
            break;
        case 1:
            //post
            request = [[WTNetWorkManager sharedKit] requestWithMethod:@"POST" URLString:@"https://httpbin.org/post" parameters:nil error:nil];
            break;
        case 2:
            //put
            request = [[WTNetWorkManager sharedKit] requestWithMethod:@"PUT" URLString:@"https://httpbin.org/put" parameters:nil error:nil];
            break;
        case 3:
            request = [[WTNetWorkManager sharedKit] requestWithMethod:@"DELETE" URLString:@"https://httpbin.org/delete" parameters:nil error:nil];
            break;
            
        default:
            break;
    }
    [[WTNetWorkManager sharedKit] dataTaskWithRequest:request completionHandler:self.complectionBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        switch (section) {
            case 0:
                return _allHeaderFields.count;
            break;
            case 1:
                return 1;
                break;
            
            default:
            break;
        }
        return 0;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        UITableViewCell *cell = nil;
        switch (indexPath.section) {
            case 0:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                NSArray *keysArray = [_allHeaderFields.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    if (obj1<obj2) {
                        return NSOrderedAscending;
                    }else{
                        return NSOrderedDescending;
                    }
                }];
                NSString *key = keysArray[indexPath.row];
                cell.textLabel.text = key;
                cell.detailTextLabel.text = _allHeaderFields[key];
            }
            break;
            case 1:{
                cell = [tableView dequeueReusableCellWithIdentifier:@"body" forIndexPath:indexPath];
                UIView *temp = [cell viewWithTag:1];
                if ([temp isKindOfClass:[UILabel class]]) {
                    UILabel *label = (UILabel*)temp;
                    NSString *string = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
                    label.text = string;
                }
            }
                break;
            
            default:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            }
            break;
        }
        return cell;
    }
#pragma mark - UITableViewDelegate

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        switch (section) {
            case 0:
                return @"HEADERS";
                break;
            case 1:
                return @"BODY";
            default:
                return @"DEFAULT";
                break;
        }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 44;
            break;
        case 1:
            return 500;
            break;
        default:
            return 44;
            break;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section == 1) {
        NSString *string = [NSString stringWithFormat:@"Elapsed Time: %f",self.useTime];
        return string;
    }
    return nil;
}

@end
