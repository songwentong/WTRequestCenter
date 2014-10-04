//
//  WTURLRequestOperation.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-29.
//  Copyright (c) 2014年 song. All rights reserved.
//  🚧施工中的类

#import <Foundation/Foundation.h>
typedef void (^WTRequestComplectionBlock)(NSURLResponse *response,NSData *data,NSError *error);
typedef void(^WTDownLoadProgressBlock)(NSUInteger bytesRead,long long totalBytesRead,long long totalBytesExpectedToRead);





@interface WTURLRequestOperation : NSOperation <NSURLConnectionDataDelegate>
{
    NSURLConnection *wtURLConnection;
    

}

@property (readwrite, nonatomic, copy) WTDownLoadProgressBlock downloadProgress;

-(instancetype)initWithRequest:(NSURLRequest*)request;
-(void)setCompletionHandler:(WTRequestComplectionBlock)handler;



@property (nonatomic, strong) NSSet *runLoopModes;

@property (nonatomic,retain) NSMutableData *responseData;
@property (nonatomic,retain,readonly)NSURLRequest *request;
@property (nonatomic,retain,readonly)NSURLResponse *response;
@property (nonatomic,retain)NSError *error;
@end
