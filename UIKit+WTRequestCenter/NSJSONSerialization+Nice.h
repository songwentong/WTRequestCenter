//
//  NSJSONSerialization+Nice.h
//  WTRequestCenter
//
//  Created by SongWentong on 3/7/16.
//  Copyright © 2016 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (Nice)
/*!
 得到一个没有null的数据,防止objectOfrKey崩溃
 */
+(id)niceJsonWithData:(NSData *)data;
@end
