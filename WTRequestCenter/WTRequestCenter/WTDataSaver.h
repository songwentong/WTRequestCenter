//
//  WTDataSaver.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-7.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTDataSaver : NSObject
//存数据
+(void)saveData:(NSData*)data withIndex:(NSInteger)index;
+(void)saveData:(NSData*)data withName:(NSString*)name;

//取数据
+(NSData*)dataWithIndex:(NSInteger)index;
+(NSData*)dataWithName:(NSString*)name;
@end
/*
 index占用表
 1：A页面XX数据
 2：B页面XX数据
 3：C页面XX数据
 
 */
