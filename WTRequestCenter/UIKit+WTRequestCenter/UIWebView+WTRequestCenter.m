//
//  UIWebView+WTRequestCenter.m
//  WTRequestCenter
//
//  Created by songwt on 14-9-28.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "UIWebView+WTRequestCenter.h"

@implementation UIWebView (WTRequestCenter)
-(void)loadWithURL:(NSURL*)url
    option:(WTRequestCenterCachePolicy)option
{
    [WTRequestCenter getWithURL:url parameters:nil option:option finish:^(NSURLResponse *response, NSData *data) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self loadHTMLString:string baseURL:nil];
    } failure:^(NSURLResponse *response, NSError *error) {
        
    }];
}


@end
