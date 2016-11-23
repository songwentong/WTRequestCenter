//
//  NSObject+JSONModel.h
//  WTRequestCenter
//
//  Created by SongWentong on 21/11/2016.
//  Copyright © 2016 song. All rights reserved.
//
/*
    我做这个方案完全是为了解决服务端的程序员数据结构错乱的情况
    比如要的是个数组,给了个字符串,要的是字符串给一个null.
 */


#import <Foundation/Foundation.h>
@protocol WTJSONModelProtocol<NSObject>
/*
    给自定义属性创建一个实例返回
 */
-(id)WTJSONModelProtocolInstanceForKey:(NSString*)key;
@end
@interface NSObject (JSONModel)
-(instancetype)initWithJSONData:(NSData*)data;
//读取json数据,给响应的属性赋值
-(void)travelData:(id)jsonData;
//尝试把对象的数据转换成json数据(支持NSCoding的部分都可以被转换)
-(NSDictionary*)attemptConvertToJSON;
@end
