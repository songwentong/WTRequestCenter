//
//  WeatherModel.h
//  WTRequestCenter
//
//  Created by SongWentong on 22/11/2016.
//  Copyright © 2016 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject
@property (strong, nonatomic) NSNumber* tz;
@property (strong, nonatomic) NSString* area;
@property (strong, nonatomic) NSString* tz_name;
@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) id null;
@property (strong, nonatomic) id current;
@property (strong, nonatomic) id day;
@property (strong, nonatomic) id hour;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* province;
@end
