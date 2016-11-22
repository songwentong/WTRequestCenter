//
//  NSJSONSerialization+Nice.h
//  WTRequestCenter
//
//  Created by SongWentong on 3/7/16.
//  Copyright © 2016 song. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSJSONSerialization (Nice)
/*!
    得到一个没有null的数据,防止objectForKey崩溃,效率没有测试,请小心使用
 */
+(nullable id)niceJsonWithData:(NSData *)data;

/*!
   把遍历到的null转变成自定义类型
 */
+(nullable id)niceJSONWithData:(NSData*)data replaceNullWith:(id(^)(id key))block;
@end
NS_ASSUME_NONNULL_END
