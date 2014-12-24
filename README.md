WTRequestCenter
===============

方便缓存的请求库，提供了方便的HTTP请求方法，传入请求url和参数，返回成功和失败的回调。
UIKit扩展提供了许多不错的方法，快速缓存图片，图片查看，缩放功能，
颜色创建，设备UUID，网页缓存，数据缓存等功能。
无需任何import和配置，目前实现了基础需求
如果有其他需要请在issue 上提出，谢谢！


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



使用方法 Usage
===============
### GET 请求，根据URL和参数去请求


用例：
```objective-c
        NSString  *url = @"http://www.baidu.com";

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"value" forKey:@"key"];
        [parameters setValue:@"v2" forKey:@"key2"];
        
        [WTRequestCenter getWithURL:url
                         parameters:parameters 
                           finished:^(NSURLResponse *response, NSData *data) 
        {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",string);
        } 
                             failed:^(NSURLResponse *response, NSError *error) 
        {
            NSLog(@"%@",response);
        }];
```
###根据索引和参数去请求

```objective-c
+(NSURLRequest*)getWithIndex:(NSInteger)index
                  parameters:(NSDictionary *)parameters
                    finished:(WTRequestFinishedBlock)finished
                      failed:(WTRequestFailedBlock)failed;
```
```objective-c
[WTRequestCenter getWithIndex:1
                   parameters:nil
                     finished:^(NSURLResponse *response, NSData *data) 
            {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",string);
            } failed:^(NSURLResponse *response, NSError *error) 
            {
                           
            }];
```
注意，使用index来请求的时候需要重写两个方法
设置一下baseURL和接口号对应的URL设置上就可以用了。
POST方法也含带索引的请求。
```objective-c
+(NSString *)baseURL
{
    NSUserDefaults *a = [self sharedUserDefaults];
    NSString *url = [a valueForKey:@"baseURL"];
    if (!url) {
        return @"http://www.xxx.com";
    }
    return url;
}

+(NSString*)URLWithIndex:(NSInteger)index
{
    NSMutableArray *urls = [[NSMutableArray alloc] init];
//    0-9
    [urls addObject:@"article/detail"];
    [urls addObject:@"interface1"];
    [urls addObject:@"interface2"];
    [urls addObject:@"interface3"];
    
    
    NSString *url = urls[index];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",[WTRequestCenter baseURL],url];
    return urlString;
}

```

### POST 请求

用例：
```objective-c
        NSString  *url = @"http://www.baidu.com";
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"aaa" forKey:@"uid"];
        [parameters setValue:@"1" forKey:@"type"];
        
        [WTRequestCenter postWithURL:url 
                          parameters:parameters 
                            finished:^(NSURLResponse *response, NSData *data) 
        {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",string);
        } 
                              failed:^(NSURLResponse *response, NSError *error)
        {
            NSLog(@"%@",response);
        }];
```

### GET+缓存策略

比普通的方法多了一个策略的选项，你根据需要去选择自己的缓存策略就可以了
```objective-c
+(NSURLRequest*)getWithURL:(NSString*)url
                parameters:(NSDictionary *)parameters
                    option:(WTRequestCenterCachePolicy)option
                  finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed;
```


###   接口路径辅助功能
      根路径的设置和获取
```objective-c
+(BOOL)setBaseURL:(NSString*)url;
+(NSString *)baseURL;
```
      接口的路径（根据索引）
```objective-c
+(NSString*)URLWithIndex:(NSInteger)index;
```


###安装
点击右侧download或者终端git clone https://github.com/swtlovewtt/WTRequestCenter
下载后找到里面的WTRequestCenter，把文件夹里面的文件粘到工程里面就可以使用了。
UIKit扩展是一个非常好的UI扩展工具，提供了图片下载方法，颜色快速创建等cagegory。

目前不提供cocoaPod安装







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





Requirement   
===============
Only need iOS 5.0 and later,no more import and Configuration!
仅仅需要iOS5 ！ 不需要其他任何import和配置


##  UIKit+WTRequestCenter
这里面提供了许多UIKit的扩展方法
- UIImageView的图片缓存
- UIImage的播放gif+图片缓存
- UIButton的图片缓存
- UIColor的快速创建
- UIDecive的扩展（uuid调用）
- UIWebView的缓存扩展（暂时不支持网页游戏的缓存）
- UIScreen 提供了一些适配屏幕的好方法，具体看注释
- UIApplication 提供了版本号和build号的获取
- WTNetworkActivityIndicatorManager提供了网络指示器

## Communication  
- 如果你**发现bug**,<a href="https://github.com/swtlovewtt/WTRequestCenter/issues">打开右侧的问题</a>
- 如果你**想做出贡献**,<a href="https://github.com/swtlovewtt/WTRequestCenter/pulls">提交一个推（pull）的请求</a>
- 如果你**有功能需求**,<a href="https://github.com/swtlovewtt/WTRequestCenter/issues">打开问题</a>




###  测试中方法


这是仿照AFNetworking写的一个请求方法，待测试。
这是一个比较强大的方法。有缓存策略和下载进度，
希望大家测试一下，给我一个反馈。
```objective-c
+(WTURLRequestOperation*)testGetWithURL:(NSString*)url
                             parameters:(NSDictionary *)parameters
                                 option:(WTRequestCenterCachePolicy)option
                               progress:(WTDownLoadProgressBlock)progress
                               finished:(WTRequestFinishedBlock)finished
                                 failed:(WTRequestFailedBlock)failed;
```


##作者
- <a href = "https://github.com/swtlovewtt">宋文通</a>
- 
