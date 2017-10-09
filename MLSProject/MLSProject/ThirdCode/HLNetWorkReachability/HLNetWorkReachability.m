//
//  NetWorkReachability.m
//  SECC01
//
//  Created by Harvey on 16/6/29.
//  Copyright © 2016年 Haley. All rights reserved.
//
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>
#import <netinet/in.h>

#import "HLNetWorkReachability.h"


NSString *kNetWorkReachabilityChangedNotification = @"kNetWorkReachabilityChangedNotification";
NSString *kNetWorkReachabilityStatusKey = @"kNetWorkReachabilityStatusKey";

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info);

typedef void(^HLNetWorkReachabilityBlock)(HLNetWorkStatus status);

@interface HLNetWorkReachability()
@property(nonatomic, copy) HLNetWorkReachabilityBlock reachabilityBlock;
@end

@implementation HLNetWorkReachability
{
    SCNetworkReachabilityRef _reachabilityRef;
}
+ (instancetype)shareManager
{
	static HLNetWorkReachability *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [self reachabilityForInternetConnection];
	});
	return instance;
}
+ (instancetype)reachabilityWithHostName:(NSString *)hostName
{
    HLNetWorkReachability *returnValue = NULL;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
    if (reachability != NULL) {
        returnValue = [[self alloc] init];
        if (returnValue != NULL) {
            returnValue->_reachabilityRef = reachability;
        } else {
            CFRelease(reachability);
        }
    }
    return returnValue;
}

+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, hostAddress);
    
    HLNetWorkReachability* returnValue = NULL;
    
    if (reachability != NULL)
    {
        returnValue = [[self alloc] init];
        if (returnValue != NULL)
        {
            returnValue->_reachabilityRef = reachability;
        }
        else {
            CFRelease(reachability);
        }
    }
    return returnValue;
}

+ (instancetype)reachabilityForInternetConnection
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    return [self reachabilityWithAddress: (const struct sockaddr *) &zeroAddress];
}

- (BOOL)startNotifier
{
    BOOL returnValue = NO;
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    if (SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context)) {
        if (SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)) {
            returnValue = YES;
        }
    }
    return returnValue;
}
- (void)setReachabilityStatusChangeBlock:(nullable void (^)(HLNetWorkStatus status))block
{
	self.reachabilityBlock = block;
}
- (HLNetWorkStatus)currentReachabilityStatus
{
    HLNetWorkStatus returnValue = HLNetWorkStatusNotReachable;
    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
    {
        returnValue = [self networkStatusForFlags:flags];
    }
    
    return returnValue;
}
- (void)callBackForCurrentStatus
{
	HLNetWorkStatus status = self.currentReachabilityStatus;
	[[NSNotificationCenter defaultCenter] postNotificationName:kNetWorkReachabilityChangedNotification object:self userInfo:@{kNetWorkReachabilityStatusKey : @(status)}];
	if (self.reachabilityBlock)
	{
		self.reachabilityBlock(status);
	}
}
- (HLNetWorkStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        // The target host is not reachable.
        return HLNetWorkStatusNotReachable;
    }
    
    HLNetWorkStatus returnValue = HLNetWorkStatusNotReachable;
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        /*
         If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
         */
        returnValue = HLNetWorkStatusWiFi;
    }
    
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        /*
         ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
         */
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            /*
             ... and no [user] intervention is needed...
             */
            returnValue = HLNetWorkStatusWiFi;
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        /*
         ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
         */
        NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                           CTRadioAccessTechnologyGPRS,
                           CTRadioAccessTechnologyCDMA1x];
        
        NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                           CTRadioAccessTechnologyWCDMA,
                           CTRadioAccessTechnologyHSUPA,
                           CTRadioAccessTechnologyCDMAEVDORev0,
                           CTRadioAccessTechnologyCDMAEVDORevA,
                           CTRadioAccessTechnologyCDMAEVDORevB,
                           CTRadioAccessTechnologyeHRPD];
        
        NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
            NSString *accessString = teleInfo.currentRadioAccessTechnology;
            if ([typeStrings4G containsObject:accessString]) {
                return HLNetWorkStatusWWAN4G;
            } else if ([typeStrings3G containsObject:accessString]) {
                return HLNetWorkStatusWWAN3G;
            } else if ([typeStrings2G containsObject:accessString]) {
                return HLNetWorkStatusWWAN2G;
            } else {
                return HLNetWorkStatusUnknown;
            }
        } else {
            return HLNetWorkStatusUnknown;
        }
    }

    return returnValue;
}

- (void)stopNotifier
{
    if (_reachabilityRef != NULL)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}

- (void)dealloc
{
    [self stopNotifier];
    if (_reachabilityRef != NULL)
    {
        CFRelease(_reachabilityRef);
    }
}


@end
static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
	HLNetWorkReachability *networkObject = (__bridge HLNetWorkReachability *)info;
	[networkObject callBackForCurrentStatus];
}
