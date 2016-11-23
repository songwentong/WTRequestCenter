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
    [stringToPrint appendFormat:@"//  this file is auto create by WTKit( https://github.com/swtlovewtt/WTRequestCenter )\n"];
    [stringToPrint appendFormat:@"//  Thank you for use my json model maker\n\n"];
    [stringToPrint appendFormat:@"@import UIKit;\n\n@interface %@ : NSObject\n",className];
    [self enumerateKeysAndObjectsUsingBlock:^(NSString* key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [stringToPrint appendFormat:@"@property (strong, nonatomic) "];
        
        if ([obj isKindOfClass:[NSString class]]) {
            [stringToPrint appendFormat:@"NSString* %@",key];
        }else if ([obj isKindOfClass:[NSNumber class]]){
            [stringToPrint appendFormat:@"NSNumber* %@",key];
        }else if ([obj isKindOfClass:[NSArray class]]){
            [stringToPrint appendFormat:@"NSArray* %@",key];
        }else{
            [stringToPrint appendFormat:@"id %@",key];
        }
        [stringToPrint appendFormat:@";\n"];
    }];
    [stringToPrint appendString:@"@end"];
//    NSLog(@"\n%@",stringToPrint);
    return stringToPrint;
}
-(NSString*)WTimplementationFromClassName:(NSString*)className
{
    NSString *implementationString = [NSString stringWithFormat:@"#import \"%@.h\"\n\n@implementation %@\n-(id)WTJSONModelProtocolInstanceForKey:(NSString*)key{\n    return nil;\n}\n@end",className,className];
    return implementationString;
}
-(void)printModelCopy{
#if DEBUG
    __block NSMutableString *stringToPrint = [NSMutableString new];
    [self enumerateKeysAndObjectsUsingBlock:^(NSString* key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [stringToPrint appendFormat:@"@property (copy, nonatomic) "];
        
        if ([obj isKindOfClass:[NSString class]]) {
            [stringToPrint appendFormat:@"NSString* %@",key];
        }else if ([obj isKindOfClass:[NSNumber class]]){
            [stringToPrint appendFormat:@"NSNumber* %@",key];
        }else if ([obj isKindOfClass:[NSArray class]]){
            [stringToPrint appendFormat:@"NSArray* %@",key];
        }else{
            [stringToPrint appendFormat:@"id %@",key];
        }
        [stringToPrint appendFormat:@";\n"];
    }];
    NSLog(@"\n%@",stringToPrint);
#endif
}
@end
