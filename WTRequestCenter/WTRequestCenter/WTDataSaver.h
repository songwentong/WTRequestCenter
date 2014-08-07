//
//  WTDataSaver.h
//  WTRequestCenter
//
//  Created by songwt on 14-8-7.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTDataSaver : NSObject
+(void)saveData:(NSData*)data withIndex:(NSInteger)index;
+(NSData*)dataWithIndex:(NSInteger)index;
+(void)saveData:(NSData*)data withName:(NSString*)name;
+(NSData*)dataWithName:(NSString*)name;
@end
