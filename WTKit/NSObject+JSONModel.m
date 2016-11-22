//
//  NSObject+JSONModel.m
//  WTRequestCenter
//
//  Created by SongWentong on 21/11/2016.
//  Copyright © 2016 song. All rights reserved.
//

#import "NSObject+JSONModel.h"
#import <objc/runtime.h>

@implementation NSObject (JSONModel)
-(instancetype)initWithJSONData:(NSData*)data{
    self = [self init];
    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [self travelData:obj];
    return self;
}

//此方法仅适用于跟结构是NSDictionary
-(void)travelData:(id)jsonData{
    //不是字典就返回
    if (![jsonData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    unsigned int propertyListCount = 0;
    objc_property_t *pList = class_copyPropertyList(self.class, &propertyListCount);
    for (int i=0; i<propertyListCount; i++) {
        const char *property = property_getAttributes(pList[i]);
        NSString *propertyString = [[NSString alloc] initWithCString:property encoding:NSUTF8StringEncoding];
        __block NSString *typeString = @"";
        __block NSString *propertyName = @"";
        [[propertyString componentsSeparatedByString:@","] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj hasPrefix:@"T"]) {
                typeString = [obj substringFromIndex:1];
            }
            if ([obj hasPrefix:@"V"]) {
                propertyName = [obj substringFromIndex:2];
            }
        }];
        if ([jsonData valueForKey:propertyName]) {
            if ([typeString containsString:@"NSString"]) {
                if ([[jsonData valueForKey:propertyName] isKindOfClass:[NSString class]]) {
                    [self setValue:jsonData[propertyName] forKey:propertyName];
                }
            }else if ([typeString containsString:@"NSNumber"]) {
                if ([[jsonData valueForKey:propertyName] isKindOfClass:[NSNumber class]]) {
                    [self setValue:jsonData[propertyName] forKey:propertyName];
                }
            }else if ([typeString containsString:@"Array"]) {
                if ([[jsonData valueForKey:propertyName] isKindOfClass:[NSArray class]]) {
                    SEL selector = @selector(WTJSONModelProtocolInstanceForKey:);
                    if ([self respondsToSelector:selector]) {
                        NSMutableArray *array = [NSMutableArray new];
                        [[jsonData valueForKey:propertyName] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            IMP imp = [self methodForSelector:selector];
                            id (*func)(id, SEL,NSString*) = (void *)imp;
                            id value = func(self, selector,propertyName);
                            if (value) {
                                [array addObject:value];
                            }
                        }];
                        [self setValue:array forKey:propertyName];
                    }
                }
            }else {
                SEL selector = @selector(WTJSONModelProtocolInstanceForKey:);
                if ([self respondsToSelector:selector]) {
                    IMP imp = [self methodForSelector:selector];
                    id (*func)(id, SEL, NSString*) = (void *)imp;
                    id value = func(self, selector,propertyName);
                    if (value) {
                        [value travelData:[jsonData valueForKey:propertyName]];
                        [self setValue:value forKey:propertyName];
                    }
                    //上面和下面的代码是等效的,下面有警告,上面没有警告.
                    //                    [self setValue:[self performSelector:selector withObject:propertyName] forKey:propertyName];
                }
            }
            
        }
        
        //NSLog(@"%@",propertyString);
    }
}


@end
