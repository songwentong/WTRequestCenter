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








##iOS编程规范

 - 使用auto layout 来做UI，这样的话就能适配各种屏幕尺寸（size classes建议用any width,any height 这样适配的是所有的屏幕）
 - 头文件能不import就不要import文件，节省编译时间.
 - 用枚举来表示状态,选项,状态码
 - 本地如果要读取实例变量就直接调用( _var ),如果要写入就调用属性的方法,这样做效率比较高
 - 懒加载模式可以节约内存
 - 命名要规范，成员变量前面加上下划线（NSString *_var）这么做的目的是区分成员变量和局部变量
 - 提交代码之前尽量去掉或者注释掉输出，多注意，方便debug.
 - 协议用"#pragma mark  <protocol>"来标记代码，这样方便快速跳到protocol里面查看方法
 - 头文件要有一定量的注释.
 - 不使用prefix header 文件,节省编译时间.
 - 图片管理使用Images.xcassets.
 - 使用@import framework 就不需要手动导入改库了。
 - View千万不要处理业务逻辑，只适合做UI
 - 能用OperationQueue的地方不要用GCD.
 - 必要的时候对一个对象设计一个初始化方法
 - 尽量使用不可变的数据
 - 用categories把类的实现断开成不同的区域
 - 用Zombies来帮助debug内存问题
 - 常量不要用宏定义指定，用静态常量声明，这样做数据的数值就不会产生变化，宏定义里面有undefine
 - 用分析去查看内存用错的地方.
 - 用Profile测试程序的性能.
 - 使用xib来调整自动布局. 不要使用 storyboard（简称sb），因为大程序里面sb文件会很大，编译特别慢，影响开发效率。

##MVC
###View的做法
View的功能就是展示UI，不储存任何数据，不参与任何业务逻辑
View的数据来源是Datasource，交互事件是Delegate

###Controller
程序的中心，对Model和V有绝对的控制权，业务的核心。

###Model
Model要求不高，用原生数据类型或者jsonModel生成的都可以。
通常情况下Controller去修改model，修改完后该刷新UI刷新UI。


###总结
 - Controller对Model和View的绝对控制权。
 - Model通过Notification来通知Controller数据发生了变化。
 - View通过Datasource或者Delegate来告知Controller自己发生了变化/是否需要发生变化。
 - Model和View不直接通信，没有任何关系。
 - Controller之间可以互相帮忙，大量的Controller结合起来就形成了一个完整的程序
