//
//  UIAlertView+WTRequestCenter.m
//  WTRequestCenter
//
//  Created by SongWentong on 14-10-16.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "UIAlertView+WTRequestCenter.h"

@implementation UIAlertView (WTRequestCenter)
+(void)showMessage:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    [alert performSelector:@selector(dismissAnimated:) withObject:@YES afterDelay:1.0];
}
@end
