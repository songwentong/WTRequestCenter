//
//  WTURLConnectionOperation.m
//  WTRequestCenter
//
//  Created by song on 14-8-1.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTURLConnectionOperation.h"
typedef NS_ENUM(NSInteger, WTOperationState) {
    WTOperationPausedState      = -1,
    WTOperationReadyState       = 1,
    WTOperationExecutingState   = 2,
    WTOperationFinishedState    = 3,
};

@interface WTURLConnectionOperation ()
@property (readwrite, nonatomic, assign) WTOperationState state;
@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;
@property (readwrite, nonatomic, strong) NSURLConnection *connection;
@property (readwrite, nonatomic, strong) NSURLRequest *request;
@property (readwrite, nonatomic, strong) NSURLResponse *response;
@property (readwrite, nonatomic, strong) NSError *error;
@property (readwrite, nonatomic, strong) NSData *responseData;
@property (readwrite, nonatomic, copy) NSString *responseString;
@property (readwrite, nonatomic, assign) NSStringEncoding responseStringEncoding;
@property (readwrite, nonatomic, assign) long long totalBytesRead;
@end
@implementation WTURLConnectionOperation
- (instancetype)initWithRequest:(NSURLRequest *)urlRequest
{
    NSParameterAssert(urlRequest);
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.request = urlRequest;
    
    return self;
}


#pragma mark - NSOperation
- (BOOL)isConcurrent
{
    return YES;
}


@end
