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
@end

@implementation GETViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:@"https://httpbin.org/get" parameters:nil error:nil];
    [[WTNetWorkManager sharedKit] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //complection
        if (!error) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpRes = (NSHTTPURLResponse*)response;
                self.allHeaderFields = httpRes.allHeaderFields;
                [self.myTableView reloadData];
                self.myTableView.hidden = NO;
            }
        }else{
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        switch (section) {
            case 0:
                return _allHeaderFields.count;
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:
            {
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
            
            default:
            break;
        }
        return cell;
    }
#pragma mark - UITableViewDelegate
    - (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        return @"HEADERS";
    }

@end
