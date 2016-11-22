//
//  WTRequestCenterTests.m
//  WTRequestCenterTests
//
//  Created by SongWentong on 2/25/16.
//  Copyright © 2016 song. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WTKit.h"
#import "WeatherModel.h"
@interface WTRequestCenterTests : XCTestCase

@end

@implementation WTRequestCenterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}



- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testJSONModel{
    NSData *data = [NSData dataWithContentsOfFile:@"/Users/songwentong/Github/WTRequestCenter/WTRequestCenterTests/JSONData"];
    WeatherModel *model = [[WeatherModel alloc] initWithJSONData:data];
    NSLog(@"%@",model.tz);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<1000; i++) {
        NSInteger integer = random();
        NSNumber *number = [NSNumber numberWithInteger:integer];
        [array addObject:number];
    }

    [self measureBlock:^{
        
        //1000  0.072 sec  2% STDEV
        //10000 6.929 sec  4% stdev
        
        [NSArray WTsortedArray2:array UsingComparator:^NSComparisonResult(NSNumber * obj1, NSNumber * obj2) {
            //左边小于右边
            if ([obj1 integerValue]<[obj2 integerValue]) {
                return NSOrderedAscending;
            }else if([obj1 integerValue]==[obj2 integerValue]) {
                //相同,返回same
                return NSOrderedSame;
            }else{
                //顺序不正确,需要切换一下
                return NSOrderedDescending;
            }
        }];
        
        
        /*
         //系统的效率果然牛逼
         //1000  0.000 sec 12% STDEV
         //10000 0.007 sec 9% STDEV
        [array sortedArrayUsingComparator:^NSComparisonResult(NSNumber * obj1, NSNumber * obj2) {
            if ([obj1 integerValue]<[obj2 integerValue]) {
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }];
        */

        
//        NSLog(@"结果是 %@",result);
    }];
    
}



-(void)testJSONParse
{
    [self measureBlock:^{
        
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
