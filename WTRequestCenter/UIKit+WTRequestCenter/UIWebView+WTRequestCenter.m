//
//  UIWebView+WTRequestCenter.m
//  WTRequestCenter
//
//  Created by songwt on 14-9-28.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "UIWebView+WTRequestCenter.h"

@implementation UIWebView (WTRequestCenter)
-(void)loadWithURL:(NSString*)url
    option:(WTRequestCenterCachePolicy)option
{
    [WTRequestCenter getWithURL:url parameters:nil option:option finished:^(NSURLResponse *response, NSData *data) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self loadHTMLString:string baseURL:nil];
    } failed:^(NSURLResponse *response, NSError *error) {
        
    }];
    
    
    
    
}


@end
