//
//  WTURLRequestOperation.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-29.
//  Copyright (c) 2014年 song. All rights reserved.
//  🚧施工中的类

#import <Foundation/Foundation.h>

@interface WTURLRequestOperation : NSOperation <NSURLConnectionDataDelegate>
{
    BOOL isReady;
    BOOL isExecuting;
    BOOL isFinished;
    BOOL isCancelled;
    NSURLConnection *wtURLConnection;
    
//    (^)handler a;
}

- (instancetype)initWithRequest:(NSURLRequest*)request;
-(void)setCompletionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler;
@property (nonatomic,retain) NSMutableData *responseData;
@property (nonatomic,retain,readonly)NSURLRequest *request;
@property (nonatomic,retain,readonly)NSURLResponse *response;
@property (nonatomic,retain)NSError *error;
@end
