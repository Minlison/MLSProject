//
//  MLSDebugInstance.m
//  MLSLogger
//
//  Created by MinLison on 16/8/18.
//  Copyright © 2016年 MinLison. All rights reserved.
//

#import "MLSDebugInstance.h"
#import "MLSDebugController.h"
#import "MLSLogDataManager.h"
#import "MLSDebugWindow.h"
#import "MLSDebugManager.h"

@interface MLSDebugInstance()
@property (strong, nonatomic) MLSDebugWindow *debugWindow;
@property (strong, nonatomic) MLSDebugController *debugController;
@property (assign, nonatomic, readwrite, getter=isRunning) BOOL running;
@end

@implementation MLSDebugInstance

+ (instancetype)shareInstance
{
        static MLSDebugInstance *instance;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                instance = [[self alloc] init];
                instance.debug = NO;
                instance.debugTextColor = [UIColor whiteColor];
                instance.debugTextFont = [UIFont systemFontOfSize:15];
                instance.debugViewAlpha = 0.7;
                instance.debugBackgroundColor = [UIColor blackColor];
                instance.maxLogCount = 100;
                instance.maxMemory = 2.0 * 1024;
                instance.radius = 30;
        });
        return instance;
}

/**
 *  开启debugView
 */
- (void)start
{
        self.running = YES;
        if ([UIApplication sharedApplication].keyWindow != nil)
        {
                [self keyWindowShow];
        }
        else
        {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWindowShow) name:UIApplicationDidFinishLaunchingNotification object:nil];
        }
}
- (void)keyWindowShow
{
        if (self.debugWindow == nil)
        {
                CGRect frame = [UIScreen mainScreen].bounds;
                CGFloat width = self.radius * 2;
                MLSDebugWindow *debugWindow = [[MLSDebugWindow alloc] initWithFrame:CGRectMake(frame.size.width - width, frame.size.height - width, width, width)];
                debugWindow.backgroundColor = [UIColor clearColor];
                debugWindow.windowLevel = UIWindowLevelAlert + 1.0;
                self.debugWindow = debugWindow;
        }
        self.debugWindow.rootViewController = [MLSDebugController debugController];
        self.debugWindow.hidden = NO;
}
/**
 *  停止debugView
 */
- (void)stop
{
        self.running = NO;
        self.debugWindow.rootViewController = nil;
        [self.debugWindow removeFromSuperview];
        self.debugWindow = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
