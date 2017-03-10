//
//  NSJSONSerialization+Nice.m
//  WTRequestCenter
//
//  Created by SongWentong on 3/7/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "NSJSONSerialization+Nice.h"
#import "NSObject+Nice.h"
@implementation NSJSONSerialization (Nice)

/*!
    得到一个没有null的数据,防止objectOfrKey崩溃
 */
+(nullable id)niceJsonWithData:(NSData *)data
{
    id result = [self JSONObjectWithData:data options:0 error:nil];
    result = [self niceJSONWithData:data replaceNullWith:^id _Nonnull(id  _Nonnull key) {
        return @"";
    }];
    return result;
}

+(nullable id)niceJSONWithData:(NSData*)data replaceNullWith:(id(^)(id key))block{
    id result = [self JSONObjectWithData:data options:0 error:nil];
//    result = [self forEach:result replaceNullWith:block];
    result = [self forEach:result replaceNullWith:block];
    return result;
}


@end
