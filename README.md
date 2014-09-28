WTRequestCenter
===============

方便缓存的请求库
无需任何import和配置，目前实现了基础需求
如果有其他需要请在issue 上提出，谢谢！


使用方法 Usage
===============
### GET 请求 
```objective-c
+(NSURLRequest*)getWithURL:(NSURL*)url
                parameters:(NSDictionary*)parameters
                  finished:(WTRequestFinishedBlock)finish
                    failed:(WTRequestFailedBlock)failure;
```
              
### POST 请求
```objective-c
+(NSURLRequest*)postWithURL:(NSURL*)url
                 parameters:(NSDictionary*)parameters
                   finished:(WTRequestFinishedBlock)finish
                     failed:(WTRequestFailedBlock)failure;
```


###   接口路径辅助功能
      根路径的设置和获取
```objective-c
+(BOOL)setBaseURL:(NSString*)url;
+(NSString *)baseURL;
```
      接口的路径（根据索引）
```objective-c
+(NSString*)urlWithIndex:(NSInteger)index;
```


### 缓存策略

缓存策略一共有5种，分别是：

    WTRequestCenterCachePolicyNormal,
    WTRequestCenterCachePolicyCacheElseWeb,
    WTRequestCenterCachePolicyOnlyCache,
    WTRequestCenterCachePolicyCacheAndRefresh,
    WTRequestCenterCachePolicyCacheAndWeb
    
    WTRequestCenterCachePolicyNormal
    普通请求，没什么特别的
    
    WTRequestCenterCachePolicyCacheElseWeb
    如果本地有就用本地，否则用网络的
 
    WTRequestCenterCachePolicyOnlyCache
    仅使用缓存缓存，不请求
 
    WTRequestCenterCachePolicyCacheAndRefresh
    本地和网络的，本地没有也会刷新,本地有也会刷新(刷新后不回调)
 
    WTRequestCenterCachePolicyCacheAndWeb
    本地有，会用，也会刷新，也会回调，本地没有会刷新
    注意：这种情况非常少见，只有调用网页的时候可能会用得到

### GET+缓存策略

比普通的方法多了一个策略的选项，你根据需要去选择自己的缓存策略就可以了
```objective-c
+(NSURLRequest*)getWithURL:(NSURL*)url
                parameters:(NSDictionary *)parameters
                    option:(WTRequestCenterCachePolicy)option
                  finished:(WTRequestFinishedBlock)finish
                    failed:(WTRequestFailedBlock)failure;
```


### POST+缓存策略
虽然POST不经常用缓存，但是每个人的需要不同，所以我同样实现了POST的缓存，有需要的可以用
```objective-c
+(NSURLRequest*)postWithURL:(NSURL*)url
                 parameters:(NSDictionary *)parameters
                     option:(WTRequestCenterCachePolicy)option
                   finished:(WTRequestFinishedBlock)finish
                     failed:(WTRequestFailedBlock)failure;
```

### WTDataSaver
WTDataSaver 是个文件存取类，用于自定的方式把数据存取到本地

#### 保存数据  name只需要传文件名就可以了，无需传路径
```objective-c
+(void)saveData:(NSData*)data
       withName:(NSString*)name
     completion:(void(^)())completion;
```

#### 读取数据 name只需要传文件名就可以了，无需传路径
```objective-c
+(void)dataWithName:(NSString*)name
         completion:(void(^)(NSData*data))completion;
```





Requirement   需要
===============
Only need iOS 5.0 and later,no more import and Configuration!
仅仅需要iOS5 ！ 不需要其他任何import和配置


## Communication  沟通
- 如果你**发现bug**,打开右侧的问题
- 如果你**想做出贡献**，提交一个推（pull）的请求
- 如果你**有功能需求**，打开问题

##  UIKit+WTRequestCenter
这里面提供了许多UIKit的扩展方法
- UIImageView的图片缓存
- UIImage的播放gif+图片缓存
- UIButton的图片缓存
- UIColor的快速创建
- UIDecive的扩展（uuid调用）



###  测试中方法


这是仿照AFNetworking写的一个请求方法，待测试
```objective-c
+(WTURLRequestOperation*)testGetWithURL:(NSURL*)url
           parameters:(NSDictionary *)parameters
               option:(WTRequestCenterCachePolicy)option
    completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler;
```
