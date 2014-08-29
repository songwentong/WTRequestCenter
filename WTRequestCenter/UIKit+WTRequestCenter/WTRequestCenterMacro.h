//
//  WTRequestCenterMacro.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-29.
//  Copyright (c) 2014年 song. All rights reserved.
//

#ifndef WTRequestCenter_WTRequestCenterMacro_h
#define WTRequestCenter_WTRequestCenterMacro_h
#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#endif
