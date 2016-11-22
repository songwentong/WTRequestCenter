//
//  WeatherModel.h
//  WTRequestCenter
//
//  Created by SongWentong on 22/11/2016.
//  Copyright © 2016 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject
@property (nonatomic,copy)NSNumber *tz;
@property (nonatomic,copy)NSString *area;
@property (nonatomic,copy)NSString *tz_name;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *province;
@end
