//
//  NSArray+Sort.m
//  Test
//
//  Created by SongWentong on 2/22/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "NSArray+Sort.h"

@implementation NSArray (Sort)
- (NSArray*)WTSortedArrayUsingComparator:(NSComparisonResult(^)(id o1,id o2))comparator
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    
    
    [NSArray sortArray:array UsingComparator:comparator];
    
    return array;
}

+(void)sortArray:(NSMutableArray*)array UsingComparator:(NSComparisonResult(^)(id o1,id o2))comparator
{
    
    //查到不合适的就交换一下位置
    [array enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx!=array.count-1) {
            NSString *obj2 = array[idx+1];
            if (comparator(obj,obj2)==NSOrderedDescending) {
                [array exchangeObjectAtIndex:idx withObjectAtIndex:idx+1];
                *stop = YES;
            }
        }
    }];
    
    //重新检查一遍,如果有不合适的顺序就重新调用本方法
    [array enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx!=array.count-1) {
            NSString *obj2 = array[idx+1];
            if (comparator(obj,obj2)==NSOrderedDescending) {
                [self sortArray:array UsingComparator:comparator];
            }
        }
    }];
    
    
    
}

@end
