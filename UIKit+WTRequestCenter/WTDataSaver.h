//
//  WTDataSaver.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-7.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter
/*
    这是一个快捷文件存取工具，由于我使用中总会遇到一些
 需要缓存的数据，于是我就想写一个数据缓存工具，我把数据
 存到Library下的Cache下的WTDataSaver下，方便管理。
 
    这个库提供了许多快捷存取文件的功能，方便使用。
                                            
                                        Mike
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WTDataSaver : NSObject

#pragma mark - 存数据 Save Data
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



#pragma mark - 读数据 Read Data
+(NSData*)dataWithName:(NSString*)name;




//异步取数据(推荐)
+(void)dataWithIndex:(NSInteger)index
          completion:(void(^)(NSData*data))completion;

+(void)dataWithName:(NSString*)name
         completion:(void(^)(NSData*data))completion;

//根据url获取文件,分线程回调
+(void)dataWithURL:(NSString*)url
 completionHandler:(void (^)(NSData *data))completion;



#pragma mark - 删除数据


+(void)removeDataWithName:(NSString*)name;


/*!
    删除所有本地数据
 */
+(void)clearAllData;



#pragma mark - 工具
//适用范围 2.0+
+(NSData*)base64EncodedData:(NSData*)data;
+(NSData*)decodeBase64Data:(NSData*)data;
//Availability
//Available in iOS 2.0 and later.


#pragma mark - 对象转换
//用于对象和Data的转换，类型可以是NSDictionary或者NSArray
+(NSData*)dataWithJSONObject:(id)obj;
+(id)JSONObjectWithData:(NSData*)data;


//根据文件名返回文件路径，用于自定义储存NSDicitonary，NSString和NSArray
+(NSString*)pathWithName:(NSString*)name;

#pragma mark - 清数据  RemoveAllData
+(void)removeAllData;

#pragma mark - 大小   file Size
+(void)fileSizeComplection:(void(^)(NSInteger size))complection;


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
