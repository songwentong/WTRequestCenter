//  
//  WTURLRequestSerialization.h
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/20.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <Foundation/Foundation.h>



//请求生成器
@interface WTURLRequestSerialization : NSObject
+(NSMutableURLRequest*)POSTRequestWithURL:(NSString*)url
                        parameters:(NSDictionary*)parameters;
@end
