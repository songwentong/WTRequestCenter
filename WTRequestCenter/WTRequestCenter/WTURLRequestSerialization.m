//
//  WTURLRequestSerialization.m
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/24.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTURLRequestSerialization.h"


@interface WTMultiFormData : NSObject

- (NSMutableURLRequest *)requestByFinalizingMultipartFormData;
@end

@interface WTMultiFormData() <WTMultipartFormData>

//请求
@property (readwrite, nonatomic, copy) NSMutableURLRequest *request;

//
@property (readwrite, nonatomic, strong) NSMutableArray *HTTPBodyParts;


@end
@implementation WTMultiFormData
- (id)initWithURLRequest:(NSMutableURLRequest *)urlRequest
{
    self = [super init];
    if (self) {
        self.request = urlRequest;
        self.HTTPBodyParts = [[NSMutableArray alloc] init];
    }
    return self;
}
- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                        error:(NSError * __autoreleasing *)error
{
    BOOL result = YES;
    assert(!name);
    assert(!fileURL);
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:fileURL];
    assert(!data);
    [self appendPartWithData:data name:name];
    
    return result;
}


- (BOOL)appendPartWithData:(NSData*)data
                      name:(NSString*)name
{
    NSDictionary *dict= @{name: data};
    [_HTTPBodyParts addObject:dict];
    return YES;
}
- (NSMutableURLRequest *)requestByFinalizingMultipartFormData
{
    if ([_HTTPBodyParts count]>0) {
        
        NSMutableData *HTTPBody = [[NSMutableData alloc] init];
        
//        分割线
        
        [_request setHTTPMethod:@"POST"];
        NSString *boundary = [[NSProcessInfo processInfo] globallyUniqueString];
        NSString *boundaryString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [_request addValue:boundaryString forHTTPHeaderField:@"Content-Type"];
        
        // define boundary separator...
        NSString *boundarySeparator = [NSString stringWithFormat:@"--%@\r\n", boundary];
        
        
        [_HTTPBodyParts enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            [HTTPBody appendData:[boundarySeparator
                                  dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *keyString = [[dict allKeys] lastObject];
            NSString *randomName = [NSString stringWithFormat:@"%d",rand()];
            [HTTPBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]];
            [HTTPBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",keyString, randomName] dataUsingEncoding:NSUTF8StringEncoding]];
            [HTTPBody appendData:[@"Content-Type:image/jpeg" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSData *data = [[dict allValues] lastObject];
            [HTTPBody appendData:data];
           
        }];
        [HTTPBody appendData:[boundarySeparator
                              dataUsingEncoding:NSUTF8StringEncoding]];
        _request.HTTPBody = HTTPBody;
        
    }
    
    return _request;
}
@end

@implementation WTURLRequestSerialization
+(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                        parameters:(NSDictionary*)parameters
{
    
    
    //    判断有效性
    assert(url != nil);
    
    
    NSURL *theURL = [NSURL URLWithString:url];
    
    //    判断有效性
    assert(theURL != nil);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL];
    [request setHTTPMethod:@"POST"];
    
    if (parameters && [[parameters allKeys] count]>0) {
        NSMutableString *paramString = [[NSMutableString alloc] init];
        
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
            [paramString appendString:str];
            [paramString appendString:@"&"];
        }];
        if([paramString hasSuffix:@"&"]){
            paramString = [[paramString substringToIndex:[paramString length]-1] mutableCopy];
            
        }
        NSData *postData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:postData];
    }
    return request;
}

+(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                               parameters:(NSDictionary*)parameters
constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block
{
    
    
    //    判断有效性
    assert(url != nil);
    
    
    NSURL *theURL = [NSURL URLWithString:url];
    
    //    判断有效性
    assert(theURL != nil);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL];
    [request setHTTPMethod:@"POST"];
    
    
    __block WTMultiFormData *formData = [[WTMultiFormData alloc] initWithURLRequest:request];
    
    if (parameters && [[parameters allKeys] count]>0) {
        NSMutableString *paramString = [[NSMutableString alloc] init];
        
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
            [paramString appendString:str];
            [paramString appendString:@"&"];
        }];
        if([paramString hasSuffix:@"&"]){
            paramString = [[paramString substringToIndex:[paramString length]-1] mutableCopy];
            
        }
        NSData *postData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:postData];
    }
    
    if (block) {
        block(formData);
    }
    return [formData requestByFinalizingMultipartFormData];
}
@end
