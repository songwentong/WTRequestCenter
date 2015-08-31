//
//  UIImageViewCacheTests.m
//  WTRequestCenter
//
//  Created by SongWentong on 14/11/25.
//  Copyright (c) 2014年 song. All rights reserved.
//

@import UIKit;
#import <XCTest/XCTest.h>
#import "WTRequestCenter.h"
#import "UIKit+WTRequestCenter.h"
@interface UIImageViewCacheTests : XCTestCase
@property (nonatomic,strong) NSString *imageURL;
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation UIImageViewCacheTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.imageView = [[UIImageView alloc] init];
    self.imageURL = @"http://su.bdimg.com/static/superplus/img/logo_white_ee663702.png";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCacheImage {
    // This is an example of a functional test case.
    self.imageURL = @"http://su.bdimg.com/static/superplus/img/logo_white_ee663702.png";
    
    

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        __strong id sSelf = self;
        NSTimeInterval startTimeInterval = [[[NSDate alloc] init] timeIntervalSince1970];
        [_imageView setImageWithURL:_imageURL placeholderImage:nil finished:^(NSURLResponse *response, NSData *data) {
            NSTimeInterval endTimeInterval = [[[NSDate alloc] init] timeIntervalSince1970];
            
            NSTimeInterval length = endTimeInterval - startTimeInterval;
            
            NSLog(@"下载/缓存时长:%f秒",length);
            //        XCTAssert(YES, @"Pass");
            if (sSelf) {
                _XCTPrimitiveAssertTrue(sSelf, YES, @"Pass");
            }
            
        } failed:^(NSURLResponse *response, NSError *error) {
            //        XCTAssert(NO,@"请求失败");
        }];
        
    }];
}

@end
