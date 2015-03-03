//
//  UIKit+WTRequestCenter.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-12.
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
/*
 使用注意
 使用gif图的时候需要import一个ImageIO.framework
 */
#import <UIKit/UIKit.h>

#ifndef WTRequestCenter_UIKit_WTRequestCenter_h
#define WTRequestCenter_UIKit_WTRequestCenter_h
#import "UIButton+WTRequestCenter.h"
#import "UIImageView+WTRequestCenter.h"
#import "UIImage+WTRequestCenter.h"
#import "UIColor+WTRequestCenter.h"
#import "UIDevice+WTRequestCenter.h"
#import "UIWebView+WTRequestCenter.h"
#import "UIAlertView+WTRequestCenter.h"
#import "WTImageViewer.h"
#import "WTNetworkActivityIndicatorManager.h"
#import "UIScreen+WTRequestCenter.h"
#import "UIApplication+WTRequestCenter.h"
#import "WTDataSaver.h"
#import "UIViewController+WTRequestCenter.h"
#import "WTNetworkHUD.h"
#import "WTNumberLabel.h"
#import "WTCycleScrollView.h"
#endif







/*
 #ifdef DEBUG
 #define NSLog(s, ...) NSLog(@"[%@@%@:%d]\n%@", NSStringFromSelector(_cmd), [@__FILE__ lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]);
 #else
 #define NSLog(s, ...) do{}while(0)
 #endif
 */






