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
-(void)travelData:(id)jsonData;
@end
