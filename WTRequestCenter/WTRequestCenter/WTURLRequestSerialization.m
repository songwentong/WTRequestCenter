//
//  WTURLRequestSerialization.m
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/24.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import "WTURLRequestSerialization.h"


//[mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"", name] forKey:@"Content-Disposition"];

static NSString const *kboundary = @"Boundary+1F52B974B3E5F39D";
@interface WTMultiFormData : NSObject <WTMultipartFormData>

- (NSMutableURLRequest *)requestByFinalizingMultipartFormData;

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
    
    
    [request setValue:@"WTNetworkCenter iOS" forHTTPHeaderField:@"User-Agent"];
    /*
     "Accept-Language" = "en;q=1";
     "Content-Length" = 29039;
     "Content-Type" = "multipart/form-data; boundary=Boundary+D2BFF93D090F9B93";
     "User-Agent" = "AFNetworking iOS Example/1.0 (iPhone Simulator; iOS 8.1; Scale/2.00)";
     */
    if (block) {
        block(formData);
    }
    return [formData requestByFinalizingMultipartFormData];
}
@end
