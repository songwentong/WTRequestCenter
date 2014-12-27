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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self loadRequest:request option:option];
    
}

- (void)loadRequest:(NSURLRequest *)request
             option:(WTRequestCenterCachePolicy)option
{
    
    if ([self isLoading]) {
        [self stopLoading];
    }
    [WTRequestCenter doURLRequest:request
                           option:option
                         finished:^(NSURLResponse *response, NSData *data) {
                             [self loadData:data
                                   MIMEType:@"text/html"
                           textEncodingName:@"utf-8"
                                    baseURL:nil];
                         } failed:^(NSURLResponse *response, NSError *error) {
                             
                         }];
}
@end
