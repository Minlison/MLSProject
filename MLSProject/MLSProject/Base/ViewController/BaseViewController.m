//
//  BaseViewController.m
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseViewController.h"
#import "MLSTransition.h"
#import "BaseLoadingView.h"
@interface BaseViewController ()
@property(nonatomic, assign, readwrite, getter=isLoading) BOOL loading;
@property(nonatomic, assign) NSTimeInterval lastLoadingTimeInterval;
@end

@implementation BaseViewController
/// MARK: - Life cycle begin
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        if (self) {
                if ([self respondsToSelector:@selector(setTransitioningDelegate:)]) {
                        self.transitioningDelegate     = [MLSTransition shared];
                        self.allowsArbitraryPresenting = YES;
                }
        }
        
        return self;
}

- (void)loadView
{
        self.controllerView = [[self class] controllerView];
        if (!self.controllerView) {
                UIView *view = [(UIView *) [[self __viewClass] alloc] initWithFrame:[UIScreen mainScreen].bounds];
                NSAssert([view isKindOfClass:[BaseView class]], @"%@ controller view is not kindof BaseView",[self class]);
                self.controllerView = (BaseView *)view;
        }
        NSAssert(self.controllerView != nil, @"can't find view for controller: %@", [self class]);
        self.view = self.controllerView;
}

- (Class)__viewClass
{
        Class    controllerClass = [self class];
        NSString *viewClassName  = [NSStringFromClass(controllerClass) stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
        Class    viewClass       = NSClassFromString(viewClassName);
        
        /// 找父类的 Controller 的 View
        while (!viewClass) {
                controllerClass = class_getSuperclass(controllerClass);
                if (controllerClass == [BaseViewController class]) {
                        return [BaseView class];
                }
                
                viewClassName = [NSStringFromClass(controllerClass) stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
                viewClass     = NSClassFromString(viewClassName);
        }
        return viewClass;
}

- (void)initSubviews
{
        [super initSubviews];
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = QMUICMI.backgroundColor;
        [self.controllerView setupView];
        self.tabBarController.tabBar.hidden = YES;
        [self configNavigationBar:(BaseNavigationBar *)self.navigationController.navigationBar];
        [self _ConfigEmptyView];
        [self _LoadViewModelData];
}

- (void)viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
        _isInDisplay = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
        [super viewDidDisappear:animated];
        _isInDisplay = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
        return UIStatusBarStyleDefault;
}

/// MARK: - Life cycle end

- (void)_LoadViewModelData
{
        
}
- (void)_ConfigEmptyView
{
        self.emptyView = [[QMUIEmptyView alloc] initWithFrame:self.view.bounds];
        self.emptyView.actionButton.layer.cornerRadius = 15;
        self.emptyView.actionButton.frame = CGRectMake(0, 0, 91, 30);
        self.emptyView.actionButton.backgroundColor = [UIColor whiteColor];
        self.emptyView.actionButton.titleLabel.font = MLSSystem14Font;
        self.emptyView.actionButton.adjustsImageWhenHighlighted = NO;
        [self.emptyView setActionButtonTitleColor:UIColorHex(0x626262)];
        [self.emptyView setActionButtonFont:MLSSystem14Font];
        [self.emptyView setActionButtonTitle:[NSString app_Refresh]];
        CGSize imgSize = CGSizeMake(90, 30);
        UIImage *image = [[UIImage imageWithColor:[UIColor whiteColor] size:imgSize] imageByRoundCornerRadius:imgSize.width * 0.5];
        [self.emptyView.actionButton setBackgroundImage:image forState:(UIControlStateNormal)];
        self.emptyView.textLabel.textColor = UIColorHex(0xBFC4C6);
        self.emptyView.textLabel.font = MLSSystem14Font;
        self.emptyView.imageViewInsets = UIEdgeInsetsMake(0, 0, 27, 0);
        self.emptyView.actionButtonInsets = UIEdgeInsetsMake(22, 0, 0, 0);
        self.emptyView.backgroundColor = UIColorHex(0xF2F2F2);
        BaseLoadingView *loadingView = [[BaseLoadingView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        self.emptyView.loadingView = loadingView;
}
/// Subclass Call Method
- (void)setLoading:(BOOL)loading animation:(BOOL)animation
{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setLoading:animation:) object:nil];
        self.lastLoadingTimeInterval = [[NSDate date] timeIntervalSince1970];
        self.loading = loading;
        if (loading)
        {
                animation ? [self showEmptyViewWithLoading] : [self showEmptyViewWithLoading:NO image:nil text:nil detailText:nil buttonTitle:nil buttonAction:nil];
        }
        else
        {
                [self setSuccess];
        }
}
- (void)setError:(NSError *)error
{
        self.loading = NO;
        self.lastLoadingTimeInterval = [[NSDate date] timeIntervalSince1970];
        [self showEmptyViewWithLoading:NO image:[UIImage none_pic] text:error.localizedDescription?:[NSString app_NeworkError] detailText:nil buttonTitle:[NSString app_Refresh] buttonAction:@selector(reloadData)];
}
- (void)setSuccess
{
        self.loading = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setSuccess) object:nil];
        NSTimeInterval subTimeInterval = [[NSDate date] timeIntervalSince1970] - self.lastLoadingTimeInterval;
        if (subTimeInterval < self.minLoadingTime)
        {
                [self performSelector:@selector(setSuccess) withObject:nil afterDelay:(self.minLoadingTime - subTimeInterval)];
        }
        else
        {
                self.lastLoadingTimeInterval = [[NSDate date] timeIntervalSince1970];
                [self hideEmptyView];
        }
}

/// Subclass Holder
- (void)reloadData
{
        [self _LoadViewModelData];
}
- (UIImage *)navigationBarBackgroundImage
{
        return [UIImage imageWithColor:QMUICMI.whiteColor];
}
- (UIImage *)navigationBarShadowImage
{
        return [UIImage nav_bar_shadows];
}
- (UIColor *)navigationBarTintColor
{
        return QMUICMI.blackColor;
}
- (BOOL)preferredNavigationBarHidden
{
        return self.prefersNavigationBarHidden || self.fd_prefersNavigationBarHidden;
}
- (void)configNavigationBar:(BaseNavigationBar *)navigationBar
{
        if ([self.navigationController.viewControllers count] > 1)
        {
                UIBarButtonItem *backItem =[QMUINavigationButton barButtonItemWithImage:[UIImage nav_ic_back_blackRenderingMode:(UIImageRenderingModeAlwaysOriginal)] position:(QMUINavigationButtonPositionLeft) target:self action:@selector(backButtonDidClick:)];
                if (@available(iOS 11.0, *))
                {
                        backItem.landscapeImagePhoneInsets = UIEdgeInsetsMake(0, -15, 0, 0);
                        backItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
                        self.navigationItem.leftBarButtonItem = backItem;
                }
                else
                {
                        UIBarButtonItem *negativeSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
                        negativeSeparator.width                = IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? -25 : -25;
                        self.navigationItem.leftBarButtonItems = @[negativeSeparator,backItem];
                }
        }
}

- (void)backButtonDidClick:(UIButton *)button
{
        if (self.isPresentedByOther) {
                [self dismissViewControllerAnimated:YES completion:nil];
        } else {
                [self.navigationController popViewControllerAnimated:YES];
        }
}

+ (__kindof BaseView * _Nullable)controllerView
{
        return nil;
}

+ (__kindof BaseViewModel * _Nullable)viewModel
{
        return nil;
}

/// RouterHandleProtocol method
+ (nullable UIViewController <JLRRouteDefinitionTargetController> *)targetControllerWithParams:(nullable NSDictionary *)parameters
{
        return nil;
}
- (void)dealloc
{
        NSLogDebug(@"-------%@ dealloc-------",self);
}
@end
