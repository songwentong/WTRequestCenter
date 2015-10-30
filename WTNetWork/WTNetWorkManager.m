//
//  WTNetWorkManager.m
//  WTRequestCenter
//
//  Created by SongWentong on 10/26/15.
//  Copyright © 2015 song. All rights reserved.
//

#import "WTNetWorkManager.h"
@interface WTNetWorkManager() 
{
    NSOperationQueue *_operationQueue;
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

    }
    return self;
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
                                     body:(NSDictionary*)body
{
    
    
    //边界
    static NSString *const kboundary = @"Boundary+1F52B974B3E5F39D";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *value = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kboundary];
    [request setValue:value forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",kboundary];
    
    NSMutableData *HTTPBody = [[NSMutableData alloc] init];
    [HTTPBody appendData:[[NSString stringWithFormat:@"--%@\r\n",kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    if (parameters) {
        __block NSInteger count = 0;
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *keyString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            [HTTPBody appendData:[keyString dataUsingEncoding:NSUTF8StringEncoding]];
            
            [HTTPBody appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
            count ++;
            if ([parameters count]!= count+1) {
                //                如果后面还有文件或者参数不是最后一个
                //Only add the boundary if this is not the last item in the post body
                [HTTPBody appendData:[endItemBoundary dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }];
    }
    
    if (body) {
        NSInteger count = body.count;
        __block NSInteger current = 0;
        [body enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *str1 =  [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", obj, key];
            [HTTPBody appendData:[str1 dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *str2 = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"image/jpeg"];
            [HTTPBody appendData:[str2 dataUsingEncoding:NSUTF8StringEncoding]];
//            [HTTPBody appendData:[[dict allValues] lastObject]];
            if (current == count-1) {
                [HTTPBody appendData:[endItemBoundary dataUsingEncoding:NSUTF8StringEncoding]];
            }
            current = current + 1;
            
        }];
    }
    
    [HTTPBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody = HTTPBody;
    [request setValue:[NSNumber numberWithUnsignedInteger:request.HTTPBody.length].stringValue forHTTPHeaderField:@"Content-Length"];
    
    return request;
}




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
