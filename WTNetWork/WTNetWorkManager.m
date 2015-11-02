//
//  WTNetWorkManager.m
//  WTRequestCenter
//
//  Created by SongWentong on 10/26/15.
//  Copyright © 2015 song. All rights reserved.
//

#import "WTNetWorkManager.h"
@import UIKit;
@interface WTNetWorkManager() 
{
    NSOperationQueue *_operationQueue;
    
    NSUInteger _connectionCount;
}
@property (readwrite, nonatomic, strong) NSURLSession *session;
@end
@implementation WTNetWorkManager
static WTNetWorkManager* kit = nil;
+(instancetype)sharedKit
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kit = [[WTNetWorkManager alloc] init];
    });
    return kit;
}


-(NSOperationQueue*)operationQueue
{
    return _operationQueue;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 8;
        _operationQueue.name = @"WTNetWork Operation Queue";
        [_operationQueue setSuspended:NO];
        self.session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:_operationQueue];
        _connectionCount = 0;

    }
    return self;
}


-(void)checkStatus
{
    BOOL networkActivityIndicatorVisible = YES;
    if (_connectionCount == 0) {
        networkActivityIndicatorVisible = NO;
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = networkActivityIndicatorVisible;
    }];
}

-(NSURLSessionDataTask*)taskWithRequest:(NSURLRequest*)request finished:(void(^)(NSData * _Nullable data, NSURLResponse * _Nullable response))finish failed:(void(^)(NSError * _Nullable error))failed
{
    _connectionCount = _connectionCount +1;
    [self checkStatus];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        _connectionCount = _connectionCount - 1;
        [self checkStatus];
        if (error) {
            if (failed) {
                failed(error);
            }
        }else
        {
            if (finish) {
                finish(data,response);
            }
        }
    }];
    [task resume];
    return task;
}


@end
@implementation WTNetWorkManager(CreatRequest)
+(NSString*)WTQueryStringFromParameters:(NSDictionary*)parameters
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    NSMutableArray *paraArray = [[NSMutableArray alloc] init];
    NSArray *sortedDict = [parameters.allKeys sortedArrayUsingDescriptors:@[sortDescriptor]];
    [sortedDict enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *value = [parameters valueForKey:obj];
        NSString *str = [NSString stringWithFormat:@"%@=%@",obj,value];
        [paraArray addObject:str];
    }];
    NSString *result = [paraArray componentsJoinedByString:@"&"];
    return result;
}

-(NSString*)WTQueryStringFromParameters:(NSDictionary*)parameters
{
    return [[self class] WTQueryStringFromParameters:parameters];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error
{
    assert(method!=nil);
    assert(URLString!=nil);
    NSURL *url = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = method;
    //    request.timeoutInterval = _timeoutInterval;
    request = [[self requestBySerializingRequest:request
                                  withParameters:parameters
                                           error:error] mutableCopy];
    return request;
}


- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                userEncode:(BOOL)userEncode
                                     error:(NSError *__autoreleasing *)error
{
    assert(method!=nil);
    assert(URLString!=nil);
    if (userEncode)
    {
        URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = method;
    //    request.timeoutInterval = _timeoutInterval;
    request = [[self requestBySerializingRequest:request
                                  withParameters:parameters
                                           error:error] mutableCopy];
    return request;
}


- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    
    assert(request!=nil);
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    //    [_HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
    //        [mutableRequest setValue:value forHTTPHeaderField:key];
    //    }];
    
    
    NSString *query = [self WTQueryStringFromParameters:parameters];
    if ([query length]>0) {
        if ([self methodNeedQuery:request.HTTPMethod]) {
            NSString *urlString = [[NSString stringWithFormat:@"%@?%@",request.URL,query] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            mutableRequest.URL = [NSURL URLWithString:urlString];
        }else
        {
            NSData *httpBodyData = [query dataUsingEncoding:NSUTF8StringEncoding];
            [mutableRequest setHTTPBody:httpBodyData];
        }
    }
    
    
    return mutableRequest;
}

-(BOOL)methodNeedQuery:(NSString*)httpMethod
{
    NSSet *set = [NSSet setWithArray:@[@"GET",@"HEAD",@"DELETE"]];
    BOOL contain = [set containsObject:httpMethod];
    return contain;
}

-(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
                                     body:(NSArray*)body
{
    
    
    //边界
    static NSString *const kboundary = @"Boundary+1F52B974B3E5F39D";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    request.HTTPMethod = @"POST";
    
    
    NSMutableData *HTTPBody = [[NSMutableData alloc] init];
    [HTTPBody appendData:[[NSString stringWithFormat:@"--%@\r\n",kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    if (parameters) {

        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *keyString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            [HTTPBody appendData:[keyString dataUsingEncoding:NSUTF8StringEncoding]];
            [HTTPBody appendData:[obj dataUsingEncoding:NSUTF8StringEncoding]];
            [HTTPBody appendData:[[NSString stringWithFormat:@"--%@\r\n",kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }];
    }
    
    if (body) {
        [body enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *name = [obj valueForKey:@"name"];
            NSString *filename = [obj valueForKey:@"filename"];
            if (!filename) {
                filename = name;
            }
            NSString *contentType = [obj valueForKey:@"contentType"];
            if (!contentType) {
                contentType = @"application/octet-stream";
            }
            NSData *content = [obj valueForKey:@"content"];
            
            
            NSString *str1 =  [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
            NSString *str2 = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", contentType];
            [HTTPBody appendData:[str1 dataUsingEncoding:NSUTF8StringEncoding]];
            [HTTPBody appendData:[str2 dataUsingEncoding:NSUTF8StringEncoding]];
            [HTTPBody appendData:content];
            [HTTPBody appendData:[[NSString stringWithFormat:@"--%@\r\n",kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }];
    }
    
    [HTTPBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody = HTTPBody;
    
    
    
    NSString *value = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kboundary];
    [request setValue:value forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSNumber numberWithUnsignedInteger:request.HTTPBody.length].stringValue forHTTPHeaderField:@"Content-Length"];
    
    return request;
}

/*
 
 --Boundary-D35F0194-BBD2-446D-B5D0-2A4B66126928
 Content-Disposition: form-data; name="fileContents"; filename="TestImage1.png"
 Content-Type: image/png
 
 --Boundary+1F52B974B3E5F39D
 Content-Disposition: form-data; name="fileContents"; filename="image.jpg"
 Content-Type: image/jpeg

 */


@end

@implementation WTNetWorkManager(GCD)
void perform(dispatch_block_t block , NSTimeInterval delay)
{
    [WTNetWorkManager performBlock:block afterDelay:delay];
}

+(void)performBlock:(dispatch_block_t)block afterDelay:(NSTimeInterval)delay
{
    
    [self performBlock:block
               inQueue:dispatch_get_main_queue()
            afterDelay:delay];
}


+(void)performBlock:(dispatch_block_t)block inQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay
{
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, delay*1000*1000*1000);
    dispatch_after(t, queue, ^{
        if (block) {
            block();
        }
    });
}


@end


//请求开始的消息
NSString * const WTNetworkingOperationDidStartNotification = @"WT Networking Operation Did Start Notification";
//请求结束的消息
NSString * const WTNetworkingOperationDidFinishNotification = @"WT Networking Operation Did Finish Notification";
