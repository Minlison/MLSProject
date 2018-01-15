//
//  MLSLogDataManager.h
//  MLSLogger
//
//  Created by MinLison on 16/8/18.
//  Copyright © 2016年 MinLison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLSLogDataManager : NSObject
+ (instancetype)shareManager;
- (void)clear;
- (void)addLogStr:(NSString *)format;
/**
 *  回调到主线程
 */
- (void)addOutPutStringObserver:(void (^)(NSString *outPut))observer;
@end
