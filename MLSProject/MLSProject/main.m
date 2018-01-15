//
//  main.m
//  MinLison
//
//  Created by MinLison on 2017/8/18.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#ifdef FBMemoryProfiler
#import <FBAllocationTracker/FBAllocationTrackerManager.h>
int main(int argc, char * argv[]) {
        [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
        [[FBAllocationTrackerManager sharedManager] enableGenerations];
        @autoreleasepool {
                return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
}
#else
int main(int argc, char * argv[]) {
        @autoreleasepool {
                return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
}
#endif
