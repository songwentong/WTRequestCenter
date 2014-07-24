WTRequestCenter
===============

方便缓存的请求库
无需任何import和配置，目前实现了基础需求
如果有其他需要请在issue 上提出，谢谢！



Requirement  
===============
Only need iOS 5.0 and later,no more!

需要
===============
仅仅需要iOS5 ！ 不需要其他任何import和配置

使用方法 Usage
===============
GET 请求
```objective-c
[WTRequestCenter getWithURL:url
                     parameters:parameters
              completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
              
              ｝
```
              
POST 请求
```objective-c
[WTRequestCenter postWithURL:url
                  parameters:parameters 
           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
           
                      ｝
```
