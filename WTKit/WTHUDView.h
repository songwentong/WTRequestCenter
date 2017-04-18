//
//  WTHUDView.h
//  WTKit
//
//  Created by SongWentong on 18/04/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WTHUDViewType) {
    WTHUDViewTypeIndicatorView,
};
@interface WTHUDView : UIView
+(instancetype)HUDForType:(WTHUDViewType)type;
@property (nonatomic,readonly)WTHUDViewType hudType;
@property (nonatomic) BOOL isLoading;
-(void)startAnimating;
-(void)stopAnimating;
@end
