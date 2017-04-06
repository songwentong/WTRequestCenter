//
//  WTURLSessionTask.h
//  WTKit
//
//  Created by SongWentong on 10/03/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WTURLSessionTask;
NS_ASSUME_NONNULL_BEGIN
@interface WTURLSessionManager:NSObject
@property (nonatomic,strong) NSURLSession *mySession;
@property dispatch_queue_t queueToProcessGetAndSetMethod;
+(instancetype)sharedSessionManager;
-(WTURLSessionTask*)getWTTaskForTask:(NSURLSessionTask*)task;
-(void)setWTTask:(WTURLSessionTask*)wtTask forKey:(NSURLSessionTask*)task;
@end
@interface WTURLSessionTask : NSObject<NSURLSessionTaskDelegate>

typedef void (^complection_block)(NSData *_Nullable data,NSURLResponse *_Nullable response,NSError *_Nullable error);
@property (nonatomic,strong) NSURLSessionDataTask *task;
@property (nonatomic,strong) NSMutableData *data;
@property (nonatomic,strong) NSError *error;
@property (nonatomic,strong) NSURLResponse *response;
@property (nonatomic,strong) complection_block complection;
//使用cacheTime时间以内的上次缓存
@property (nonatomic) NSTimeInterval cacheTime;
- (void)resume;
- (void)suspend;
- (void)cancel;
@end
@interface WTURLSessionDataTask : WTURLSessionTask <NSURLSessionDataDelegate>
@property (nonatomic) BOOL shouldCache;
@end
NS_ASSUME_NONNULL_END
