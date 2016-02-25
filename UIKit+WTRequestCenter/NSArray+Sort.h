//
//  NSArray+Sort.h
//  Test
//
//  Created by SongWentong on 2/22/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Sort)
- (NSArray*)WTSortedArrayUsingComparator:(NSComparisonResult(^)(id o1,id o2))comparator;
@end
