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
    

    [WTRequestCenter doURLRequest:request
                           option:option
                         finished:^(NSURLResponse *response, NSData *data) {
                             
                             if ([self isLoading]) {
                                 [self stopLoading];
                             }
                             
                             [self loadData:data
                                   MIMEType:@"text/html"
                           textEncodingName:@"gbk"
                                    baseURL:nil];
                         } failed:^(NSURLResponse *response, NSError *error) {
                             
                         }];
}
@end
