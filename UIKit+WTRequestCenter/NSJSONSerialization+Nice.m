//
//  NSJSONSerialization+Nice.m
//  WTRequestCenter
//
//  Created by SongWentong on 3/7/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "NSJSONSerialization+Nice.h"

@implementation NSJSONSerialization (Nice)

/*!
    得到一个没有null的数据,防止objectOfrKey崩溃
 */
+(nullable id)niceJsonWithData:(NSData *)data
{
    id result = [self JSONObjectWithData:data options:0 error:nil];
    result = [self replaceNullJSON:result];
    return result;
}

//去掉null
+(id)replaceNullJSON:(id)obj
{
    if (obj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *array1 = (NSArray*)obj;
            NSMutableArray *array2 = [NSMutableArray array];

            [array1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array2 addObject:[self replaceNullJSON:obj]];
            }];
            return array2;
        }
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict1 = (NSDictionary*)obj;
            NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
            [dict1 enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [dict2 setValue:[self replaceNullJSON:obj] forKey:key];
            }];
            return dict2;
        }
        
    }
      
    return @"";
}
@end
