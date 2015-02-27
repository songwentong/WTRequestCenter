//
//  WTURLRequestSerialization.m
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/24.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTURLRequestSerialization.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

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
    assert(data!=nil);
    assert(name!=nil);
    
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
static NSString *defaultUserAgentString = nil;
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
        defaultUserAgentString = [[self class] defaultUserAgentString];
        [_HTTPRequestHeaders setValue:defaultUserAgentString forKey:@"User-Agent"];
        self.timeoutInterval = WTURLRequestSerializationTimeoutTimeInterval;
        
    }
    return self;
}



+(NSString*)defaultUserAgentString
{
    NSString *result = @"";
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    // Attempt to find a name for this application
    NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
    }
    
    NSData *latin1Data = [appName dataUsingEncoding:NSUTF8StringEncoding];
    appName = [[NSString alloc] initWithData:latin1Data encoding:NSISOLatin1StringEncoding] ;
    
    // If we couldn't find one, we'll give up (and ASIHTTPRequest will use the standard CFNetwork user agent)
    if (!appName) {
        return nil;
    }
    
    NSString *appVersion = nil;
    NSString *marketingVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *developmentVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    if (marketingVersionNumber && developmentVersionNumber) {
        if ([marketingVersionNumber isEqualToString:developmentVersionNumber]) {
            appVersion = marketingVersionNumber;
        } else {
            appVersion = [NSString stringWithFormat:@"%@ rv:%@",marketingVersionNumber,developmentVersionNumber];
        }
    } else {
        appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
    }
    
    NSString *deviceName;
    NSString *OSName;
    NSString *OSVersion;
    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    
#if TARGET_OS_IPHONE
    UIDevice *device = [UIDevice currentDevice];
				deviceName = [device model];
				OSName = [device systemName];
				OSVersion = [device systemVersion];
#else
    deviceName = @"Macintosh";
				OSName = @"Mac OS X";
    
				OSErr err;
				SInt32 versionMajor, versionMinor, versionBugFix;
				err = Gestalt(gestaltSystemVersionMajor, &versionMajor);
				if (err != noErr) return nil;
				err = Gestalt(gestaltSystemVersionMinor, &versionMinor);
				if (err != noErr) return nil;
				err = Gestalt(gestaltSystemVersionBugFix, &versionBugFix);
				if (err != noErr) return nil;
				OSVersion = [NSString stringWithFormat:@"%u.%u.%u", versionMajor, versionMinor, versionBugFix];
    
#endif
    result = [NSString stringWithFormat:@"%@ %@ (%@; %@ %@; %@)", appName, appVersion, deviceName, OSName, OSVersion, locale];
    return result;
}

#pragma mark - 请求串
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

#pragma mark - 请求的生成


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
    request.timeoutInterval = _timeoutInterval;
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
+(NSDate*)dateFromCachedURLResponse:(NSCachedURLResponse*)response
{
    NSTimeInterval time = [[response.userInfo valueForKey:@"responseTime"] floatValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
    return date;
}
@end


@implementation WTJSONRequestSerialization
static WTJSONRequestSerialization *sharedWTJSONRequestSerialization = nil;
+(instancetype)sharedRequestSerialization
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWTJSONRequestSerialization = [[WTJSONRequestSerialization alloc] init];
    });
    return sharedWTJSONRequestSerialization;
}

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    //    (request);
    assert(!request);
    
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if (parameters) {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
        
        [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters
                                                                    options:NSJSONWritingPrettyPrinted
                                                                      error:error]];
    }
    
    return mutableRequest;
}

@end