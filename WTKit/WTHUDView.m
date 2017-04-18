//
//  WTHUDView.m
//  WTKit
//
//  Created by SongWentong on 18/04/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

#import "WTHUDView.h"
@interface WTHUDView()
@property (nonatomic,strong)UIActivityIndicatorView *indicatorView;
@property (nonatomic,readwrite)WTHUDViewType hudType;
@end
@implementation WTHUDView

+(instancetype)HUDForType:(WTHUDViewType)type{
    switch (type) {
        case WTHUDViewTypeIndicatorView:{
            WTHUDView *hudView = [[WTHUDView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            hudView.hudType = type;
            return hudView;
        }
            break;
            
        default:
            break;
    }
    WTHUDView *hudView = [[WTHUDView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    return hudView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIActivityIndicatorView *tempIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.indicatorView = tempIndicator;
        self.userInteractionEnabled = NO;
        tempIndicator.frame = self.bounds;
        [self addSubview:tempIndicator];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        self.layer.cornerRadius = 8;
    }
    return self;
}
-(void)startAnimating{
    [_indicatorView startAnimating];
}
-(void)stopAnimating{
    [_indicatorView stopAnimating];
    self.hidden = YES;
}

@end
