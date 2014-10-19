//
//  ViewController.h
//  WTRequestCenter
//
//  Created by song on 14-7-19.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
    UITableView *wtTableView;
    NSMutableArray *requestTypesArray;
    
    UITableViewCell *imageCell;
}

@end
