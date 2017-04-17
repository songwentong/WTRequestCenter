//
//  WTNetWorkManager.m
//  WTRequestCenter
//
//  Created by SongWentong on 10/26/15.
//  Copyright © 2015 song. All rights reserved.
//

#import "WTNetWorkManager.h"
#if TARGET_OS_IOS
@import UIKit;
#endif




@interface WTNetWorkManager() <NSURLSessionDelegate>
{
    NSUInteger _connectionCount;
}
@property (nonatomic,strong) NSMutableDictionary *HTTPRequestHeaders;
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


static NSURLCache *cache =nil;
+(NSURLCache*)sharedURLcache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSURLCache alloc] initWithMemoryCapacity:10*1024*1024
                                              diskCapacity:1000*1024*1024
                                                  diskPath:@"WTRequestCenter"];
    });
    return cache;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
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
}
-(WTURLSessionDataTask*)taskWithMethod:(NSString *)method
                             URLString:(NSString *)URLString
                            parameters:(NSDictionary*)parameters
                                 error:(NSError *__autoreleasing *)error
                              finished:(void(^)(NSData * _Nullable data, NSURLResponse * _Nullable response))finish
                                failed:(void(^)(NSError * _Nullable error))failed
{
    NSURLRequest *request = [self requestWithMethod:method URLString:URLString parameters:parameters error:error];
    WTURLSessionDataTask *task = (WTURLSessionDataTask*)[self taskWithRequest:request finished:finish failed:failed];
    return task;
}
-(WTURLSessionDataTask*)taskWithRequest:(NSURLRequest*)request
                               finished:(void(^)(NSData * _Nullable data, NSURLResponse * _Nullable response))finish
                             failed:(void(^)(NSError * _Nullable error))failed
{
    return [self dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (failed) {
                failed(error);
            }
        }else{
            if (finish) {
                finish(data,response);
            }
        }
        
    }];
}
-(WTURLSessionDataTask*)dataTaskWithRequest:(NSURLRequest*)request
                      completionHandler:(complection_block)completionHandler
{
    assert(request!=nil);
//    _connectionCount = _connectionCount +1;
//    [self checkStatus];
    WTURLSessionDataTask *wtTask = [WTURLSessionDataTask new];
    NSURLSession *session = [WTURLSessionManager sharedSessionManager].mySession;
    wtTask.complection = completionHandler;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    wtTask.task = task;
    wtTask.complection = completionHandler;
    [[WTURLSessionManager sharedSessionManager] setWTTask:wtTask forKey:task];
    [wtTask resume];
    return wtTask;
}
-(WTURLSessionDataTask*)cachedDataTaskWithRequest:(NSURLRequest*)request
                            completionHandler:(complection_block)completionHandler
{
    assert(request!=nil);
    
    
    WTURLSessionDataTask *wtTask = [WTURLSessionDataTask new];
    NSURLSession *session = [WTURLSessionManager sharedSessionManager].mySession;
    wtTask.complection = completionHandler;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    wtTask.task = task;
    wtTask.complection = completionHandler;
    wtTask.cacheTime = -1;
    [[WTURLSessionManager sharedSessionManager] setWTTask:wtTask forKey:task];
    [wtTask resume];
    return wtTask;
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
static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary*)parameters
                                     error:(NSError *__autoreleasing *)error
{
    assert(method!=nil);
    assert(URLString!=nil);
    NSURL *url = nil;
    url = [NSURL URLWithString:URLString];
    
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
    
    [_HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [mutableRequest setValue:value forHTTPHeaderField:key];
    }];
    
    
    NSString *query = [self WTQueryStringFromParameters:parameters];
    if ([query length]>0) {
        if ([self methodNeedQuery:request.HTTPMethod]) {
            NSString *urlString = nil;
            
            //获得URL可用字符集
            NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
            //转码为URL + 百分号的字符串
            [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
            urlString = [[NSString stringWithFormat:@"%@?%@",request.URL,query] stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            //转码为URL可用的字符集
            urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
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


@end




//请求开始的消息
NSString * const WTNetworkingOperationDidStartNotification = @"WT Networking Operation Did Start Notification";
//请求结束的消息
NSString * const WTNetworkingOperationDidFinishNotification = @"WT Networking Operation Did Finish Notification";
