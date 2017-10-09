//
//  NetWorkReachability.h
//  SECC01
//
//  Created by Harvey on 16/6/29.
//  Copyright © 2016年 Haley. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HLNetWorkStatus) {
    HLNetWorkStatusNotReachable = 0,
    HLNetWorkStatusUnknown = 1,
    HLNetWorkStatusWWAN2G = 2,
    HLNetWorkStatusWWAN3G = 3,
    HLNetWorkStatusWWAN4G = 4,
    
    HLNetWorkStatusWiFi = 9,
};

FOUNDATION_EXTERN NSString *kNetWorkReachabilityChangedNotification;
FOUNDATION_EXTERN NSString *kNetWorkReachabilityStatusKey;

@interface HLNetWorkReachability : NSObject
//  reachabilityForInternetConnection
+ (instancetype)shareManager;
/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;

- (BOOL)startNotifier;

- (void)stopNotifier;


- (void)setReachabilityStatusChangeBlock:(nullable void (^)(HLNetWorkStatus status))block;

- (HLNetWorkStatus)currentReachabilityStatus;


@end

NS_ASSUME_NONNULL_END
