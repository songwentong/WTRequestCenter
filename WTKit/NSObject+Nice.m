//
//  NSObject+Nice.m
//  WTRequestCenter
//
//  Created by SongWentong on 3/10/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "NSObject+Nice.h"

@implementation NSObject (Nice)
void WTLog(NSString *format,...)
{
#if DEBUG
    va_list argumentList;
    va_start(argumentList, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:argumentList];
    // clean up
    va_end(argumentList);

//    NSLog(@"%@\n%@",[NSThread callStackSymbols][1],string);
    NSLog(@"%@",string);
#else
    //do nothing
#endif
}

void DEBUGBlock(dispatch_block_t block){
#if DEBUG
    if (block) {
        block();
    }
#endif
}
void ReleaseBlock(dispatch_block_t block)
{
#if DEBUG
    //do nothing
#else
    if (block) {
        block();
    }
#endif
}

void perform(dispatch_block_t block , NSTimeInterval delay)
{
    [NSObject performBlock:block afterDelay:delay];
}

void safeSyncInMainQueue( dispatch_block_t block)
{
    if (block) {
        if ([NSThread isMainThread]) {
            block();
        }else{
            dispatch_sync(dispatch_get_main_queue(), block);
        }
    }
}



+(void)performBlock:(dispatch_block_t)block afterDelay:(NSTimeInterval)delay
{
    
    [self performBlock:block
               inQueue:dispatch_get_main_queue()
            afterDelay:delay];
}


+(void)performBlock:(dispatch_block_t)block inQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay
{
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, delay*NSEC_PER_SEC);
    dispatch_after(t, queue, ^{
        if (block) {
            block();
        }
    });
}

+(id)forEach:(id)obj replaceNullWith:(id(^)(id key))block
{
    
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
            if ([obj isEqual:[NSNull null]] && block) {
                [dict2 setValue:block(key) forKey:key];
            }else{
                id result = [self forEach:obj replaceNullWith:block];
                [dict2 setValue:result forKey:key];
            }
           
        }];
        return dict2;
    }
    return obj;
    
}
@end
