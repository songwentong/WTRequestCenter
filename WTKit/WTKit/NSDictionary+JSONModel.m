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
@end
