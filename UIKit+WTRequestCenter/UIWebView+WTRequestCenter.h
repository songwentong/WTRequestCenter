//
//  UIWebView+WTRequestCenter.h
//  WTRequestCenter
//
//  Created by songwt on 14-9-28.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRequestCenter.h"
@interface UIWebView (WTRequestCenter)

-(void)loadWithURL:(NSString*)url
            option:(WTRequestCenterCachePolicy)option;



- (void)loadRequest:(NSURLRequest *)request
             option:(WTRequestCenterCachePolicy)option;
@end
