WTRequestCenter
===============


方便缓存的请求库，提供了方便的HTTP请求方法，传入请求url和参数，返回成功和失败的回调。
UIKit扩展提供了许多不错的方法，快速缓存图片，图片查看，缩放功能，
颜色创建，设备UUID，网页缓存，数据缓存等功能。
无需任何import和配置，目前实现了基础需求，
如果有其他需要请在issue 上提出，谢谢！
完全64位支持。


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
            NSString *string = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
            NSLog(@"%@",string);
        }
                             failed:^(NSURLResponse *response, NSError *error)
        {
            NSLog(@"%@",response);
        }];
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

### GET+缓存
```objective-c
[WTRequestCenter GETUsingCache:@"url"
                    parameters:nil
                      finished:^(NSURLResponse *response, NSData *data) {
                              
                      } failed:^(NSURLResponse *response, NSError *error) {
                              
                          }];
```
已经完成的请求缓存下来，用作下次使用。没有请求过的重新请求，请求完后缓存。


Debug模式
默认开启，会输出请求的对象，响应时间或者错误信息，
可以再WTRequestCenter.h里面关闭。

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





需要版本  
===============
iOS 5.0


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
