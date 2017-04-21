//
//  NSDictionary+JSONModel.h
//  WTRequestCenter
//
//  Created by SongWentong on 22/11/2016.
//  Copyright © 2016 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONModel)
/*
    自动读取json数据来创建h文件里面对应的字符串,
    只需要writeToFile就可以用来
 */
-(NSString*)WTModelStringFromClassName:(NSString*)className;
/*
    自动读取json数据来创建m文件里面对应的字符串,
    只需要writeToFile就可以用来
 */
-(NSString*)WTimplementationFromClassName:(NSString*)className;

@end
/*
 base type
 NSNumber NSString NSString NSArray NSDictionary NSNull
 */
