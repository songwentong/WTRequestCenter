//
//  NSArray+Sort.h
//  Test
//
//  Created by SongWentong on 2/22/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Sort)
/*!
    失败的排序方法
 */
- (NSArray*)WTSortedArrayUsingComparator:(NSComparisonResult(^)(id o1,id o2))comparator;

/*!
 速度是系统提供排序效率的千分之一
 */
+(NSArray*)WTsortedArray2:(NSMutableArray*)array UsingComparator:(NSComparisonResult(^)(id o1,id o2))comparator;
@end
