//
//  NSOperationQueue+Nice.h
//  WTRequestCenter
//
//  Created by SongWentong on 3/8/16.
//  Copyright © 2016 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (Nice)

//全局共享的queue
+(instancetype)globalQueue;
@end
