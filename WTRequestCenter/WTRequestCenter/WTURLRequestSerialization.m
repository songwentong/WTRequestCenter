//
//  WTURLRequestSerialization.m
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/24.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTURLRequestSerialization.h"


//超时时间
NSTimeInterval const WTURLRequestSerializationTimeoutTimeInterval = 30;
//边界
static NSString *const kboundary = @"Boundary+1F52B974B3E5F39D";
//User-Agent
static NSString *const WTReuqestCenterUserAgent = @"WTURLRequestUserAgent";

@interface WTMultiFormData : NSObject <WTMultipartFormData>

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSMutableURLRequest *requestByFinalizingMultipartFormData;

//请求
@property (readwrite, nonatomic, copy) NSMutableURLRequest *request;

//
@property (readwrite, nonatomic, strong) NSMutableArray *HTTPBodyParts;

@end

@implementation WTMultiFormData
- (instancetype)initWithURLRequest:(NSMutableURLRequest *)urlRequest
{
    self = [super init];
    if (self) {
        self.request = urlRequest;
        self.HTTPBodyParts = [[NSMutableArray alloc] init];

        [_HTTPBodyParts setValue:WTReuqestCenterUserAgent forKey:@"User-Agent"];
    }
    return self;
}
- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                        error:(NSError * __autoreleasing *)error
{
    BOOL result = YES;
    assert(!fileURL);
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:fileURL];
    
    [self appendPartWithData:data name:name];
    
    return result;
}


- (BOOL)appendPartWithData:(NSData*)data
                      name:(NSString*)name
{
    assert(!data);
    assert(!name);
    
    NSDictionary *dict= @{name: data};
    [_HTTPBodyParts addObject:dict];
    return YES;
}
- (NSMutableURLRequest *)requestByFinalizingMultipartFormData
{
    if ([_HTTPBodyParts count]>0) {
        
        
        NSMutableData *HTTPBody = [_request.HTTPBody mutableCopy];
        if (!HTTPBody) {
            HTTPBody = [[NSMutableData alloc] init];
        }
//        分割线
        
        [_request setHTTPMethod:@"POST"];
        NSInteger count = [_HTTPBodyParts count];
        [_HTTPBodyParts enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            
            NSString *keyString = [[dict allKeys] lastObject];
            
            
//            1.边界
            [HTTPBody appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
            [HTTPBody appendData:[kboundary
                                  dataUsingEncoding:NSUTF8StringEncoding]];
//          2.Content-Disposition
            [HTTPBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";  \n\n",keyString] dataUsingEncoding:NSUTF8StringEncoding]];
//          3.Content-Type
            [HTTPBody appendData:[@"Content-Type:image/jpeg\n\n" dataUsingEncoding:NSUTF8StringEncoding]];

            NSData *data = [[dict allValues] lastObject];
            
            
//            4.图片数据
            [HTTPBody appendData:data];
            
            
            [HTTPBody appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
            [HTTPBody appendData:[kboundary
                                  dataUsingEncoding:NSUTF8StringEncoding]];
            if (count == idx+1) {
                [HTTPBody appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
            }
           
        }];
       
        _request.HTTPBody = HTTPBody;
        
    }
    
    return _request;
}
@end
@interface WTURLRequestSerialization()
{
    
}

//请求头
@property (readwrite, nonatomic, strong) NSMutableDictionary *HTTPRequestHeaders;
@end

@implementation WTURLRequestSerialization
static WTURLRequestSerialization *sharedSerialization = nil;

+(instancetype)sharedRequestSerialization
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSerialization = [self instance];
    });
    return sharedSerialization;
}

+(instancetype)instance
{
    return [[WTURLRequestSerialization alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.HTTPRequestHeaders = [[NSMutableDictionary alloc] init];
        self.timeoutInterval = WTURLRequestSerializationTimeoutTimeInterval;
    }
    return self;
}

#pragma mark - 请求串
+(NSString*)stringFromParameters:(NSDictionary*)parameters
{
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString* value, BOOL *stop) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
        [paramString appendString:str];
        [paramString appendString:@"&"];
        
    }];
    if([paramString hasSuffix:@"&"]){
        paramString = [[paramString substringToIndex:[paramString length]-1] mutableCopy];
    }
    return paramString;
}

-(NSString*)stringFromParameters:(NSDictionary*)parameters
{
    return [[self class] stringFromParameters:parameters];
}

#pragma mark - 请求的生成
+(NSMutableURLRequest*)GETRequestWithURL:(NSString*)url
                              parameters:(NSDictionary*)parameters
{
    return [[self sharedRequestSerialization] GETRequestWithURL:url
                                                     parameters:parameters];
}
-(NSMutableURLRequest*)GETRequestWithURL:(NSString*)url
                              parameters:(NSDictionary*)parameters
{
    NSMutableURLRequest *request = nil;
    assert(url!=nil);
    
    NSString *parameterString = [self stringFromParameters:parameters];
    
    NSString *string;
    if ([parameterString length]>0) {
        string = [NSString stringWithFormat:@"%@?%@",url,parameterString];
    }else
    {
        string = url;
    }
//    处理中文
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *requestURL = [NSURL URLWithString:string];
    
    assert(requestURL != nil);
    
    request = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:_timeoutInterval];
    [_HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];

    return request;
}

+(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
{
    
    
    return [[self sharedRequestSerialization] POSTRequestWithURL:url
                                                      parameters:parameters];
}
-(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
{
    
    
    //    判断有效性
    assert(url != nil);
    
    
    NSURL *theURL = [NSURL URLWithString:url];
    
    //    判断有效性
    assert(theURL != nil);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:_timeoutInterval];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[[self stringFromParameters:parameters] dataUsingEncoding:NSUTF8StringEncoding]];
    [_HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    return request;
}

+(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
                constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block
{
    
    
    return [[self sharedRequestSerialization] POSTRequestWithURL:url
                                                      parameters:parameters
                                       constructingBodyWithBlock:block];
}

-(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block
{
    
    
    //    判断有效性
    assert(url != nil);
    
    
    NSURL *theURL = [NSURL URLWithString:url];
    
    //    判断有效性
    assert(theURL != nil);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:_timeoutInterval];
    [request setHTTPMethod:@"POST"];
    
    
    
    
    if (parameters && [[parameters allKeys] count]>0) {
        
        NSMutableData *myData = [[NSMutableData alloc] init];
        [myData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
        [myData appendData:[kboundary dataUsingEncoding:NSUTF8StringEncoding]];
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
//            Content-Disposition: form-data; name="abc"
            NSString *keyString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"",key];
            [myData appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [myData appendData:[keyString dataUsingEncoding:NSUTF8StringEncoding]];
                        [myData appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:[kboundary dataUsingEncoding:NSUTF8StringEncoding]];
        }];
        [request setHTTPBody:myData];
    }
    
    __block WTMultiFormData *formData = [[WTMultiFormData alloc] initWithURLRequest:request];
    
    NSString *value = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kboundary];
    [request setValue:value forHTTPHeaderField:@"Content-Type"];
    
    [_HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    if (block) {
        block(formData);
    }
    return [formData requestByFinalizingMultipartFormData];
}

+(NSMutableURLRequest*)PUTRequestWithURL:(NSString*)url
                              parameters:(NSDictionary*)parameters
{
    return [[self sharedRequestSerialization] PUTRequestWithURL:url
                                                     parameters:parameters];
}
-(NSMutableURLRequest*)PUTRequestWithURL:(NSString*)url
                              parameters:(NSDictionary*)parameters
{
    NSMutableURLRequest *request = nil;
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:_timeoutInterval];
    [request setHTTPBody:[[self stringFromParameters:parameters] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"PUT"];
    [_HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    return request;
}


+(NSMutableURLRequest*)HEADRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
{
    NSMutableURLRequest *request = nil;
    
    
    
    return request;
}



+(NSString*)stringFromDate:(NSDate*)date
{
    NSString *result = @"";
//    NSDate *nowDate = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    NSTimeInterval nowInterval = [nowDate timeIntervalSince1970];
//    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    
    return result;
}


#pragma mark - 实例方法
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    [self.HTTPRequestHeaders setValue:value forKey:field];
}
- (NSString *)valueForHTTPHeaderField:(NSString *)field {
    return [self.HTTPRequestHeaders valueForKey:field];
}


#pragma mark - 其他

//获得响应时间
+(NSDate*)dateFromHTTPURLResponse:(NSHTTPURLResponse*)response
{
    NSHTTPURLResponse *httpRes = (NSHTTPURLResponse*)response;
    NSDictionary *dict = httpRes.allHeaderFields;
    NSString *dateString = [dict valueForKey:@"Date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E, dd MMM yyyy hh:mm:ss VVVV";
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}
@end
