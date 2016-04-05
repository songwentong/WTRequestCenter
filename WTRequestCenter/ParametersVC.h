//
//  ParametersVC.h
//  WTRequestCenter
//
//  Created by SongWentong on 4/5/16.
//  Copyright © 2016 song. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ParametersVC;
@protocol ParametersVCDelegate
@optional
-(void)parametersVCGetParameters:(ParametersVC*)vc;
@end
@interface ParametersVC : UITableViewController
@property (nonatomic,weak) id <ParametersVCDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *parameters;
@end
