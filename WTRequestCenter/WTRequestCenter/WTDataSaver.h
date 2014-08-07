//
//  WTDataSaver.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-7.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import <Foundation/Foundation.h>

@interface WTDataSaver : NSObject
//存数据（都是异步）
+(void)saveData:(NSData*)data withIndex:(NSInteger)index;
+(void)saveData:(NSData*)data withName:(NSString*)name;
//完成回调
+(void)saveData:(NSData *)data
      withIndex:(NSInteger)index
     completion:(void (^)())completion;

+(void)saveData:(NSData*)data
       withName:(NSString*)name
     completion:(void(^)())completion;


//同步取数据（不推荐）
+(NSData*)dataWithIndex:(NSInteger)index;
+(NSData*)dataWithName:(NSString*)name;

//异步取数据(推荐)
+(void)dataWithIndex:(NSInteger)index
          completion:(void(^)(NSData*data))completion;

+(void)dataWithName:(NSString*)name
         completion:(void(^)(NSData*data))completion;

#pragma mark - 清数据
+(void)removeAllData;
+(void)fileSizeComplection:(void(^)(NSInteger size))complection;

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)
+(void)testiOS7;
#endif
@end
/*
 index占用表
 1：A页面XX数据
 2：B页面XX数据
 3：C页面XX数据
 
 */

/*
 name 占用表
 a：a页面a数据
 b：b页面b数据
 c：c页面c数据
 */
