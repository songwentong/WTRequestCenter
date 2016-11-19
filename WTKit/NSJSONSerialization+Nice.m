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
    result = [self forEach:result replaceNullWith:^id{
        return @"";
    } ];
    return result;
}

+(nullable id)niceJSONWithData:(NSData*)data replaceNullWith:(id(^)())block{
    id result = [self JSONObjectWithData:data options:0 error:nil];
    result = [self forEach:result replaceNullWith:block];
    return result;
}

+(id)forEach:(id)obj replaceNullWith:(id(^)())block{

    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *array1 = (NSArray*)obj;
        NSMutableArray *array2 = [NSMutableArray array];
        
        [array1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id result = [self forEach:obj replaceNullWith:block];
            [array2 addObject:result];
        }];
        return array2;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict1 = (NSDictionary*)obj;
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
        [dict1 enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            id result = [self forEach:obj replaceNullWith:block];
            [dict2 setValue:result forKey:key];
        }];
        return dict2;
    }
    
    if ([obj isKindOfClass:[NSNull class]]) {
        if (block) {
            return block();
        }
    }else{
        return obj;
    }
    return obj;

}
@end
