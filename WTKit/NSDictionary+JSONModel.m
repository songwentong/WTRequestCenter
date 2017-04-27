//
//  NSDictionary+JSONModel.m
//  WTRequestCenter
//
//  Created by SongWentong on 22/11/2016.
//  Copyright © 2016 song. All rights reserved.
//

#import "NSDictionary+JSONModel.h"

@implementation NSDictionary (JSONModel)
-(NSString*)WTModelStringFromClassName:(NSString*)className{
    
    __block NSMutableString *stringToPrint = [NSMutableString new];
    [stringToPrint appendFormat:@"//\n"];
    [stringToPrint appendFormat:@"//  %@.h\n",className];
    [stringToPrint appendFormat:@"//  this file is auto create by WTKit\n"];
    [stringToPrint appendFormat:@"//  site:https://github.com/swtlovewtt/WTRequestCenter\n"];
    [stringToPrint appendFormat:@"//  Thank you for use my json model maker\n"];
    [stringToPrint appendFormat:@"//\n//\n\n@import WTKit;\n@protocol WTJSONModelProtocol;\n"];
    [stringToPrint appendFormat:@"@import UIKit;\n\n@interface %@ : NSObject<WTJSONModelProtocol>\n\n",className];
    [self enumerateKeysAndObjectsUsingBlock:^(NSString* key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [stringToPrint appendFormat:@"@property (strong, nonatomic) "];
        
        if ([obj isKindOfClass:[NSString class]]) {
            [stringToPrint appendFormat:@"NSString"];
            [stringToPrint appendFormat:@" *%@",key];
        }else if ([obj isKindOfClass:[NSNumber class]]){
            [stringToPrint appendFormat:@"NSNumber"];
            [stringToPrint appendFormat:@" *%@",key];
        }else if ([obj isKindOfClass:[NSArray class]]){
            [stringToPrint appendFormat:@"NSArray"];
            [stringToPrint appendFormat:@" *%@",key];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            [stringToPrint appendFormat:@"NSDictionary"];
            [stringToPrint appendFormat:@" *%@",key];
        }else if ([obj isKindOfClass:[NSNull class]]){
            [stringToPrint appendFormat:@"NSNull"];
            [stringToPrint appendFormat:@" *%@",key];
        }else{
            [stringToPrint appendFormat:@"id %@",key];
        }
        
        [stringToPrint appendFormat:@";\n"];
    }];
    [stringToPrint appendString:@"\n@end"];
//    NSLog(@"\n%@",stringToPrint);
    return stringToPrint;
}
-(NSString*)WTimplementationFromClassName:(NSString*)className
{
    NSMutableString *stringToPrint = [NSMutableString string];
    [stringToPrint appendFormat:@"//\n"];
    [stringToPrint appendFormat:@"//  %@.m\n",className];
    [stringToPrint appendFormat:@"//  this file is auto create by WTKit\n"];
    [stringToPrint appendFormat:@"//  site:https://github.com/swtlovewtt/WTRequestCenter\n"];
    [stringToPrint appendFormat:@"//  Thank you for use my json model maker\n"];
    [stringToPrint appendFormat:@"//\n"];
    [stringToPrint appendFormat:@"//\n\n"];
    [stringToPrint appendFormat:@"#import \"%@.h\"\n\n@implementation %@\n\n#pragma mark - WTJSONModelProtocol\n-(id)WTJSONModelProtocolInstanceForKey:(NSString*)key{\n    return nil;\n}\n\n@end",className,className];
    
    return stringToPrint;
}


/*
    递归遍历,深度优先.容易导致栈溢出.
 */
+(void)travel:(NSObject*)travelObj{
    if ([travelObj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *tempDict = (NSDictionary*)travelObj;
        [tempDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self travel:obj];
        }];
    }else if ([travelObj isKindOfClass:[NSArray class]]){
        NSArray *tempArray = (NSArray*)travelObj;
        [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self travel:obj];
        }];
    }else{
        NSLog(@"%@",travelObj);
    }
}
/*
 do-while和while-do的共同点是里面的条件都必须为true才会继续执行
 广度优先,防栈溢出的遍历
 */
+(void)travelDict:(NSDictionary*)dict{
    NSMutableArray *objsToTravel = [NSMutableArray array];
    [objsToTravel addObject:dict];
    while (objsToTravel.count != 0) {
        NSMutableArray *tempArray = [NSMutableArray array];
        [objsToTravel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSArray class]]) {
                [tempArray addObjectsFromArray:obj];
            }else if ([obj isKindOfClass:[NSDictionary class]]){
                NSDictionary *tempDict = obj;
                [tempArray addObjectsFromArray:[tempDict allValues]];
            }else{
                NSLog(@"%@",obj);
            }
        }];
        [objsToTravel removeAllObjects];
        [objsToTravel addObjectsFromArray:tempArray];
    }
}

@end
