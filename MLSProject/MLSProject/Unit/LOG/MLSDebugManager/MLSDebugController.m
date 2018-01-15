//
//  MLSDebugController.m
//  MLSLogger
//
//  Created by MinLison on 16/8/18.
//  Copyright © 2016年 MinLison. All rights reserved.
//

#import "MLSDebugController.h"
#import "MLSDebugControl.h"
#import "MLSDebugView.h"
#import "MLSDebugInstance.h"
#import "MLSLogDataManager.h"
#import <objc/runtime.h>

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface UIViewController (MLSDebugHack)
@property (assign, nonatomic) BOOL mls_debug_hidden;
@property (assign, nonatomic) UIStatusBarStyle mls_debug_statusBarStyle;
@end


@implementation UIViewController (MLSDebugHack)
- (void)setMls_debug_statusBarStyle:(UIStatusBarStyle)mls_debug_statusBarStyle
{
        objc_setAssociatedObject(self, @selector(mls_debug_statusBarStyle), @(mls_debug_statusBarStyle), OBJC_ASSOCIATION_ASSIGN);
}
- (UIStatusBarStyle)mls_debug_statusBarStyle
{
        return [objc_getAssociatedObject(self, @selector(mls_debug_statusBarStyle)) integerValue];
}
- (void)setMls_debug_hidden:(BOOL)mls_debug_hidden
{
        objc_setAssociatedObject(self, @selector(mls_debug_hidden), @(mls_debug_hidden), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)mls_debug_hidden
{
        return [objc_getAssociatedObject(self, @selector(mls_debug_hidden)) boolValue];
}
+ ( void )load
{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                
                Class class = [self class];
                // When swizzling a class method, use the following:
                // Class class = object_getClass((id)self);
                
                // exchange viewWillAppear
                SEL originalSelector = @selector(setNeedsStatusBarAppearanceUpdate);
                SEL swizzledSelector = @selector(mls_setNeedsStatusBarAppearanceUpdate);
                
                Method originalMethod = class_getInstanceMethod(class, originalSelector);
                Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
                
                BOOL didAddMethod =
                class_addMethod(class,
                                originalSelector,
                                method_getImplementation(swizzledMethod),
                                method_getTypeEncoding(swizzledMethod));
                
                if (didAddMethod)
                {
                        class_replaceMethod(class,
                                            swizzledSelector,
                                            method_getImplementation(originalMethod),
                                            method_getTypeEncoding(originalMethod));
                }
                else
                {
                        method_exchangeImplementations(originalMethod, swizzledMethod);
                }
        });
}
- (void)mls_setNeedsStatusBarAppearanceUpdate
{
        if ( ![self isKindOfClass:[MLSDebugController class]] && [MLSDebugInstance shareInstance].isRunning)
        {
                [MLSDebugController debugController].mls_debug_hidden = [self prefersStatusBarHidden];
                [MLSDebugController debugController].mls_debug_statusBarStyle = [self preferredStatusBarStyle];
                return [[MLSDebugController debugController] setNeedsStatusBarAppearanceUpdate];
        }
        return [self mls_setNeedsStatusBarAppearanceUpdate];
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end


@interface MLSDebugController()
@property (strong, nonatomic) MLSDebugControl *debugControl;
@property (weak, nonatomic) MLSDebugView *debugView;
@end

@implementation MLSDebugController
+ (instancetype)debugController
{
        static MLSDebugController *instance;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                instance = [[self alloc] init];
        });
        return instance;
}
- (void)loadView
{
        MLSDebugView *view = [[MLSDebugView alloc] init];
        self.debugView = view;
        self.view = view;
}
- (void)viewDidLoad
{
        [super viewDidLoad];
        self.view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.debugControl];
        
        [[MLSLogDataManager shareManager] addOutPutStringObserver:^(NSString *outPut) {
                if (outPut == nil)
                {
                        [self.debugView clear];
                }
                else
                {
                        [self.debugView setString:outPut];
                }
        }];
}
- (void)showOrHideDebug:(BOOL)isShow
{
        if (isShow)
        {
                [self showDebugView];
        }
        else
        {
                [self hideDebugView];
        }
}
- (void)showDebugView
{
        [self.debugView showDebug];
}
- (void)hideDebugView
{
        [self.debugView hideDebug];
}
- (MLSDebugControl *)debugControl
{
        if (_debugControl == nil) {
                __weak typeof (self) weakSelf = self;
                _debugControl = [MLSDebugControl debugControlWithShowDebugViewBlock:^(BOOL isShow) {
                        __weak typeof (weakSelf) strongSelf = weakSelf;
                        [strongSelf showOrHideDebug:isShow];
                }];
                _debugControl.frame = CGRectMake(0, 0, 50, 50);
        }
        return _debugControl;
}
- (BOOL)prefersStatusBarHidden
{
        if ([[[NSBundle mainBundle].infoDictionary valueForKey:@"UIViewControllerBasedStatusBarAppearance"] boolValue])
        {
                return self.mls_debug_hidden;
        }
        else
        {
                return [UIApplication sharedApplication].statusBarHidden;
        }
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
        if ([[[NSBundle mainBundle].infoDictionary valueForKey:@"UIViewControllerBasedStatusBarAppearance"] boolValue])
        {
                return self.mls_debug_statusBarStyle;
        }
        else
        {
                return [UIApplication sharedApplication].statusBarStyle;
        }
}
@end

