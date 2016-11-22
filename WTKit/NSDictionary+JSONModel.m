//
//  NSDictionary+JSONModel.m
//  WTRequestCenter
//
//  Created by SongWentong on 22/11/2016.
//  Copyright © 2016 song. All rights reserved.
//

#import "NSDictionary+JSONModel.h"

@implementation NSDictionary (JSONModel)
-(void)printModel{
#if DEBUG
    __block NSMutableString *stringToPrint = [NSMutableString new];
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
    NSLog(@"\n%@",stringToPrint);
#endif
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
