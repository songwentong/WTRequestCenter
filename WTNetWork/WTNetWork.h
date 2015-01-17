//
//  WTNetWork.h
//  WTRequestCenter
//
//  Created by SongWentong on 14/12/29.
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
#ifndef WTRequestCenter_WTNetWork_h
#define WTRequestCenter_WTNetWork_h

#if !__has_feature(objc_arc)
#error WTRequestCenter must be built with ARC.
// You can turn on ARC for only WTRequestCenter files by adding -fobjc-arc to the build phase for each of its files.
#endif

#import "WTRequestCenter.h"
#import "WTURLRequestOperation.h"
#import "WTURLRequestSerialization.h"
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)
#import "WTURLSessionManager.h"
#endif

#endif
