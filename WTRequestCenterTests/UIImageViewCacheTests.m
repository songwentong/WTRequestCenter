//
//  UIImageViewCacheTests.m
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/25.
//  Copyright (c) 2014年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WTRequestCenter.h"
#import "UIKit+WTRequestCenter.h"
@interface UIImageViewCacheTests : XCTestCase
@property (nonatomic,strong) NSString *imageURL;
@end

@implementation UIImageViewCacheTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCacheImage {
    // This is an example of a functional test case.
    UIImageView *imageView = [[UIImageView alloc] init];
    NSTimeInterval startTimeInterval = [[[NSDate alloc] init] timeIntervalSince1970];
    [imageView setImageWithURL:_imageURL placeholderImage:nil finished:^(NSURLResponse *response, NSData *data) {
        NSTimeInterval endTimeInterval = [[[NSDate alloc] init] timeIntervalSince1970];
        
        NSTimeInterval length = endTimeInterval - startTimeInterval;
    
        NSLog(@"下载时长%f",length);
        XCTAssert(YES, @"Pass");
    } failed:^(NSURLResponse *response, NSError *error) {
        XCTAssert(NO,@"请求失败");
    }];
    

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
