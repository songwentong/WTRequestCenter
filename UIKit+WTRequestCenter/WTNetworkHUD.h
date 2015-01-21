//
//  NetworkHUD.h
//  WTRequestCenter
//
//  Created by SongWentong on 15/1/21.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTNetworkHUD;
@protocol WTNetworkHUDDelegate <NSObject>

@optional
-(UIImage*)wtNetWorkHUDImage:(WTNetworkHUD*)hud;


@end
@interface WTNetworkHUD : UIView
@property (nonatomic,weak) id<WTNetworkHUDDelegate> delegate;
-(void)reloadData;
-(void)startAnimating;
-(void)stopAnimating;
@end
