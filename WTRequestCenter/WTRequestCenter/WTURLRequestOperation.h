//
//  WTURLRequestOperation.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-29.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter
/*
 这是一个方便的缓存式网络请求的缓存库，在网络不好
 或者没有网络的情况下方便读取缓存来看。
 
 使用方法很简单，只需要传URL和参数就可以了。
 
 还提供上传图片功能，下载图片功能，缓存图片功能
 还有JSON解析功能，还提供来一个URL的表让你来填写
 然后直接快捷取URL。
 希望能帮到你，谢谢。
 如果有任何问题可以在github上向我提出
 Mike
 
 */
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
