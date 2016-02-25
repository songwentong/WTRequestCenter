//
//  WTRequestCenterTests.m
//  WTRequestCenterTests
//
//  Created by SongWentong on 2/25/16.
//  Copyright © 2016 song. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIKit+WTRequestCenter.h"
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

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<100; i++) {
        NSInteger integer = random();
        NSNumber *number = [NSNumber numberWithInteger:integer];
        [array addObject:number];
    }
    [self measureBlock:^{

        /*
         0.08s
       [array sortedArrayUsingComparator:^NSComparisonResult(NSNumber * obj1, NSNumber * obj2) {
           if ([obj1 integerValue]<[obj2 integerValue]) {
               return NSOrderedAscending;
           }else{
               return NSOrderedDescending;
           }
       }];
         
         */
        [array WTSortedArrayUsingComparator:^NSComparisonResult(NSNumber * obj1, NSNumber * obj2) {
            if ([obj1 integerValue]<[obj2 integerValue]) {
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }];
    }];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
