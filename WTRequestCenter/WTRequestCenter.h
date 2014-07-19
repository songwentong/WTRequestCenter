//
//  WTRequestCenter.h
//  TestCache
//
//  Created by song on 14-7-19.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTRequestCenter : NSObject

+(NSMutableURLRequest*)getWithURL:(NSURL*)url completionHandler:(void (^)(NSURLResponse* response,NSData *data))handler;

@end
