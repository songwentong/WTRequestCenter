//
//  NSDictionary+JSONModel.h
//  WTRequestCenter
//
//  Created by SongWentong on 22/11/2016.
//  Copyright © 2016 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONModel)
-(NSString*)WTModelStringFromClassName:(NSString*)className;
-(NSString*)WTimplementationFromClassName:(NSString*)className;
-(void)printModelCopy;
@end
