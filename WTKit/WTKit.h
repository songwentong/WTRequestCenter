//
//  UIKit+WTRequestCenter.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-12.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter
/*
 欢迎使用我的WTKit
 这是一个便捷的网络库,并提供一些UIKit和Foundation的扩展
 本来只想提供一些网络库给大家使用的,但是使用的时候发现需要集成很多其他的功能,
 比如创建一个颜色创建,比如图片缓存,比如屏幕截图,比如输出重写,我都做了一些集成.
 希望能帮到你，谢谢。
 如果有任何问题可以在github上向我提出
 Mike
 
 */

#ifndef WTRequestCenter_UIKit_WTRequestCenter_h
#define WTRequestCenter_UIKit_WTRequestCenter_h
#import "WTNetWorkManager.h"
#import "UIButton+WTRequestCenter.h"
#import "UIImageView+WTRequestCenter.h"
#import "UIColor+WTRequestCenter.h"
#import "UIDevice+WTRequestCenter.h"
#import "UIAlertView+WTRequestCenter.h"
#import "WTImageViewer.h"
#import "WTNetworkActivityIndicatorManager.h"
#import "UIScreen+WTRequestCenter.h"
#import "WTDataSaver.h"
#import "WTNumberLabel.h"
#import "WTCycleScrollView.h"
#import "UIViewController+Nice.h"
#import "CALayer+Nice.h"
#import "UIView+Nice.h"
#import "UIApplication+Nice.h"
#import "UIImage+Nice.h"


//-------------Foundation
#import "NSObject+Nice.h"
#import "NSArray+Nice.h"
#import "NSJSONSerialization+Nice.h"
#import "NSOperationQueue+Nice.h"
#import "NSMutableArray+Nice.h"
#import "NSObject+JSONModel.h"
#import "NSDictionary+JSONModel.h"
#endif




/*
    以下是我不熟悉,并且已经集成的非常好的功能,推荐给大家
    版本记录器   GBVersionTracking
    钥匙串管理   UICKeyChainStore
    悬浮框管理   MBProgressHUD
 */


/*
 #ifdef DEBUG
 #define NSLog(s, ...) NSLog(@"[%@@%@:%d]\n%@", NSStringFromSelector(_cmd), [@__FILE__ lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]);
 #else
 #define NSLog(s, ...) do{}while(0)
 #endif
 */






