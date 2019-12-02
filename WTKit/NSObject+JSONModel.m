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
-(instancetype)initWTJSONModelWithData:(NSData*)data{
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
    //取出属性列表
    objc_property_t *pList = class_copyPropertyList(self.class, &propertyListCount);
    //遍历每一条属性
    for (int i=0; i<propertyListCount; i++) {
        //获得属性
        const char *property = property_getAttributes(pList[i]);
        NSString *propertyString = [[NSString alloc] initWithCString:property encoding:NSUTF8StringEncoding];
        /*
         T@"NSString",&,N,V_area
         T@"NSArray",&,N,V_Array
         T@"NSNumber",&,N,V_tz
         
         Code
         Meaning
         R
         The property is read-only (readonly).
         C
         The property is a copy of the value last assigned (copy).
         &
         The property is a reference to the value last assigned (retain).
         N
         The property is non-atomic (nonatomic).
         G<name>
         The property defines a custom getter selector name. The name follows the G (for example, GcustomGetter,).
         S<name>
         The property defines a custom setter selector name. The name follows the S (for example, ScustomSetter:,).
         D
         The property is dynamic (@dynamic).  手动实现get/set方法
         W
         The property is a weak reference (__weak).    弱引用
         P
         The property is eligible for garbage collection.  符合垃圾收集
         t<encoding>
         Specifies the type using old-style encoding.     属性名
         */
        /*
         Table 6-1  Objective-C type encodings
         Code
         Meaning
         c
         A char
         i
         An int
         s
         A short
         l
         A long
         l is treated as a 32-bit quantity on 64-bit programs.
         q
         A long long
         C
         An unsigned char
         I
         An unsigned int
         S
         An unsigned short
         L
         An unsigned long
         Q
         An unsigned long long
         f
         A float
         d
         A double
         B
         A C++ bool or a C99 _Bool
         v
         A void
         *
         A character string (char *)
         @
         An object (whether statically typed or typed id)
         #
         A class object (Class)
         :
         A method selector (SEL)
         [array type]
         An array
         {name=type...}
         A structure
         (name=type...)
         A union
         bnum
         A bit field of num bits
         ^type
         A pointer to type
         ?
         An unknown type (among other things, this code is used for function pointers)
         */
        __block NSString *typeString = @"";
        __block NSString *propertyName = @"";
        //属性描述字符串,T是类型,V是属性名
        [[propertyString componentsSeparatedByString:@","] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj hasPrefix:@"T"]) {
                typeString = [obj substringFromIndex:1];
            }
            if ([obj hasPrefix:@"V"]) {
                propertyName = [obj substringFromIndex:2];
            }
        }];
        //用属性名从数据源取出value
        if ([jsonData valueForKey:propertyName]) {
            //检查到数据存在
            //检查数据类型,string,number或者是数组,如果class对应上了,就赋值
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
            }else if ([typeString containsString:@"NSNull"]){
                [self setValue:[NSNull null] forKey:propertyName];
            }else {
                //如果是字典,就递归实现此操作
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
            
        }else{
            
        }
        
        //NSLog(@"%@",propertyString);
    }
}

-(NSDictionary*)attemptConvertToJSON
{
    unsigned int propertyListCount = 0;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
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
        id value = [self valueForKey:propertyName];
        if ([value isKindOfClass:[NSString class]]) {
            [dictionary setValue:[self valueForKey:propertyName] forKey:propertyName];
        }else if ([value isKindOfClass:[NSNumber class]]){
            [dictionary setValue:[self valueForKey:propertyName] forKey:propertyName];
        }else if ([value isKindOfClass:[NSArray class]]){
            NSMutableArray *array = [NSMutableArray array];
            [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj attemptConvertToJSON]) {
                    [array addObject:[obj attemptConvertToJSON]];
                }
            }];
            [dictionary setValue:array forKey:propertyName];
        }else{
            if ([value attemptConvertToJSON]) {
                [dictionary setValue:[value attemptConvertToJSON] forKey:propertyName];
            }
        }
    }
    return dictionary;
}
@end
