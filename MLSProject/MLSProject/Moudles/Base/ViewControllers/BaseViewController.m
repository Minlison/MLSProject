//
//  BaseViewController.m
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseViewController.h"
#import "MLSTransition.h"
#import "BaseLoadingView.h"
#import "BaseCommentToolBar.h"
static CGFloat const kEmotionViewHeight = 232;
@interface BaseViewController ()
@property(nonatomic, assign, readwrite, getter=isLoading) BOOL loading;
@property(nonatomic, assign, readwrite, getter=isFirstAppear) BOOL firstAppear;
@property(nonatomic, assign) NSTimeInterval lastLoadingTimeInterval;
@property(nonatomic, strong, readwrite) UIView <BaseCommentToolBarProtocol> *commentToolBar;
@property(nonatomic, strong) UIControl *maskControl;
@property(nonatomic, strong) QMUIKeyboardManager *keyboardManager;
@property(nonatomic, strong) QMUIEmotionInputManager *qqEmotionManager;
@property(nonatomic, assign, readwrite, getter=isDataLoaded) BOOL dataLoaded;
@end

@implementation BaseViewController
@synthesize inDisplay = _inDisplay;
@synthesize minLoadingTime = _minLoadingTime;

/// MARK: - Life cycle begin

- (void)didInitialized
{
        [super didInitialized];
        if ([self respondsToSelector:@selector(setTransitioningDelegate:)])
        {
                self.transitioningDelegate     = [MLSTransition shared];
                self.allowsArbitraryPresenting = YES;
        }
        self.firstAppear = YES;
        
        self.minLoadingTime = 0.2;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:WGViewControllerReloadDataNotifaction object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}
- (void)loadView
{
        _controllerView = [[self class] controllerView];
        if (!_controllerView)
        {
                UIView *view = [(UIView *) [[self __viewClass] alloc] initWithFrame:[UIScreen mainScreen].bounds];
                NSAssert([view conformsToProtocol:@protocol(BaseControllerViewProtocol)], @"%@ controller view is not conforms To Protocol BaseControllerViewProtocol",[self class]);
                _controllerView = (UIView <BaseControllerViewProtocol> *)view;
        }
        NSAssert(_controllerView != nil, @"can't find view for controller: %@", [self class]);
        if (!_controllerView)
        {
                _controllerView = [[BaseControllerView alloc] init];
        }
        self.view = _controllerView;
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
                        return [BaseControllerView class];
                }
                
                viewClassName = [NSStringFromClass(controllerClass) stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
                viewClass     = NSClassFromString(viewClassName);
        }
        return viewClass;
}

- (void)initSubviews
{
        [super initSubviews];
        [self configEmptyView];
        [self initCommentView];
        self.view.clipsToBounds = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = UIColorForBackground;
        [self.controllerView setupView];
}
- (void)applicationWillResignActive
{
        if (self.isFirstAppear)
        {
                self.firstAppear = NO;
        }
}
- (void)viewWillAppear:(BOOL)animated
{
        [super viewWillAppear:animated];
        
//        CATransition *navTransition = [CATransition animation];
//        navTransition.removedOnCompletion = YES;
//        navTransition.duration = .1;
//        navTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//        navTransition.type = kCATransitionPush;
//        navTransition.subtype = kCATransitionPush;
//        [self.navigationController.navigationBar.layer addAnimation:navTransition forKey:nil];
        
        id<UIViewControllerTransitionCoordinator> tc =self.transitionCoordinator;
        
        if(tc && [tc initiallyInteractive])
        {
                [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                        [self.navigationController setNavigationBarHidden:self.fd_prefersNavigationBarHidden animated:NO];
                }];
        }
        else
        {
                [self.navigationController setNavigationBarHidden:self.fd_prefersNavigationBarHidden animated:NO];
        }
        if (self.navigationController) {
                [self.navigationController.tabBarController.tabBar setTranslucent:NO];
        } else {
                [self.tabBarController.tabBar setTranslucent:NO];
        }
        [self configNavigationBar:(BaseNavigationBar *)self.navigationController.navigationBar];
}
- (void)viewWillDisappear:(BOOL)animated
{
        [super viewWillDisappear:animated];
        if (self.isFirstAppear)
        {
                self.firstAppear = NO;
        }
//        CATransition *navTransition = [CATransition animation];
//        navTransition.removedOnCompletion = YES;
//        navTransition.duration = .1;
//        navTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//        navTransition.type = kCATransitionFromTop;
//        navTransition.subtype = kCATransitionFromTop;
//        [self.navigationController.navigationBar.layer addAnimation:navTransition forKey:nil];
        
        //        id<UIViewControllerTransitionCoordinator> tc =self.transitionCoordinator;
        //        if(tc && [tc initiallyInteractive])
        //        {
        //                [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //                        [self.navigationController setNavigationBarHidden:self.fd_prefersNavigationBarHidden animated:NO];
        //                }];
        //        }
        //        else
        //        {
        //                [self.navigationController setNavigationBarHidden:self.fd_prefersNavigationBarHidden animated:NO];
        //        }
}

- (void)viewDidLayoutSubviews
{
        [super viewDidLayoutSubviews];
        [self.view bringSubviewToFront:self.maskControl];
        if (self.qqEmotionManager.emotionView && [self.view.subviews containsObject:self.qqEmotionManager.emotionView])
        {
                [self.view bringSubviewToFront:self.qqEmotionManager.emotionView];
        }
        
        [self.view bringSubviewToFront:self.commentToolBar];
        if ( self.emptyView && ![self commentForceLayoutBringToTop] )
        {
                [self.view bringSubviewToFront:self.emptyView];
        }
        [self.emptyView setNeedsLayout];
        [self.emptyView layoutIfNeeded];
}


- (void)viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
        _inDisplay = YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
        [super viewDidDisappear:animated];
        _inDisplay = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
        return UIStatusBarStyleDefault;
}
- (UIView<BaseControllerViewProtocol> *)controllerView
{
        if (!_controllerView) {
                [self loadViewIfNeeded];
        }
        return _controllerView;
}
/// MARK: - Life cycle end

- (void)configEmptyView
{
        self.emptyView = [[QMUIEmptyView alloc] initWithFrame:self.view.bounds];
        self.emptyView.actionButton.layer.cornerRadius = 15;
        self.emptyView.actionButton.frame = CGRectMake(0, 0, 91, 30);
        self.emptyView.actionButton.backgroundColor = [UIColor whiteColor];
        self.emptyView.actionButton.titleLabel.font = WGSystem14Font;
        self.emptyView.actionButton.adjustsImageWhenHighlighted = NO;
        [self.emptyView setActionButtonTitleColor:UIColorHex(0x626262)];
        [self.emptyView setActionButtonFont:WGSystem14Font];
        [self.emptyView setActionButtonTitle:[NSString app_Refresh]];
        CGSize imgSize = CGSizeMake(90, 30);
        UIImage *image = [[UIImage imageWithColor:[UIColor whiteColor] size:imgSize] imageByRoundCornerRadius:imgSize.width * 0.5];
        [self.emptyView.actionButton setBackgroundImage:image forState:(UIControlStateNormal)];
        self.emptyView.textLabelTextColor = UIColorHex(0xBFC4C6);
        self.emptyView.textLabelFont = WGSystem14Font;
        self.emptyView.imageViewInsets = UIEdgeInsetsMake(0, 0, 27, 0);
        self.emptyView.actionButtonInsets = UIEdgeInsetsMake(22, 0, 0, 0);
        self.emptyView.contentView.backgroundColor = UIColorHex(0xF2F2F2);
        self.emptyView.backgroundColor = UIColorHex(0xF2F2F2);
        BaseLoadingView *loadingView = [[BaseLoadingView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        self.emptyView.loadingView = loadingView;
}

/// Subclass Call Method
- (void)setLoading:(BOOL)loading animation:(BOOL)animation
{
        if (self.loading == loading)
        {
                return;
        }
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
        [self setError:error completion:nil];
}
- (void)setError:(NSError *)error completion:(void (^)(void))completion
{
        self.dataLoaded = YES;
        self.loading = NO;
        self.lastLoadingTimeInterval = [[NSDate date] timeIntervalSince1970];
        NSString *errorDes = error.localizedDescription?:[NSString app_NeworkError];
        if (![error isAppError])
        {
                errorDes = [NSString app_RequestNormalError];
        }
        [self showEmptyViewWithLoading:NO image:[UIImage none_pic] text:errorDes detailText:nil buttonTitle:[NSString app_Refresh] buttonAction:@selector(reloadData)];
        if (completion)
        {
                completion();
        }
}
- (void)setSuccess
{
        [self setSuccessCompletion:nil];
}
- (void)setSuccessCompletion:(void (^)(void))completion
{
        self.dataLoaded = YES;
        self.loading = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setSuccess) object:nil];
        NSTimeInterval subTimeInterval = [[NSDate date] timeIntervalSince1970] - self.lastLoadingTimeInterval;
        if (subTimeInterval < self.minLoadingTime)
        {
                @weakify(self);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.minLoadingTime - subTimeInterval + 0.05) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        @strongify(self);
                        [self setSuccessCompletion:completion];
                });
        }
        else
        {
                self.lastLoadingTimeInterval = [[NSDate date] timeIntervalSince1970];
                [self hideEmptyView];
                if (completion)
                {
                        completion();
                }
        }
}
/// Subclass Holder
- (void)loadData
{
        
}
- (void)reloadData
{
        self.dataLoaded = NO;
        [self loadData];
}
- (UIImage *)navigationBarBackgroundImage
{
        return [UIImage imageWithColor:QMUICMI.whiteColor];
}
- (UIImage *)navigationBarShadowImage
{
        return [[UIImage nav_bar_shadows] qmui_imageWithAlpha:0.8];
}
- (UIColor *)navigationBarTintColor
{
        return QMUICMI.blackColor;
}
- (BOOL)navigationBarTranslucent
{
        return NO;
}
- (BOOL)tabBarTranslucent
{
        return NO;
}
- (BOOL)preferredNavigationBarHidden
{
        return self.prefersNavigationBarHidden || self.fd_prefersNavigationBarHidden;
}
//- (BOOL)forceEnableInteractivePopGestureRecognizer
//{
//        return YES;
//}
//- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable
//{
//        return YES;
//}
//- (BOOL)shouldCustomNavigationBarTransitionWhenPushAppearing
//{
//        return YES;
//}
//- (BOOL)shouldCustomNavigationBarTransitionWhenPushDisappearing
//{
//        return YES;
//}
//- (BOOL)shouldCustomNavigationBarTransitionWhenPopAppearing
//{
//        return YES;
//}
//- (BOOL)shouldCustomNavigationBarTransitionWhenPopDisappearing
//{
//        return YES;
//}
- (void)configNavigationBar:(BaseNavigationBar *)navigationBar
{
        if ([self forceEnableNavigationBarBackItem] || [self.navigationController.viewControllers count] > 1 || self.navigationController.isPresentedByOther || self.isPresentedByOther)
        {
                QMUINavigationButton *btn = [[QMUINavigationButton alloc] initWithImage:[self navigationBarBackItemImage]];
                btn.adjustsImageTintColorAutomatically = NO;
                UIBarButtonItem *backItem =[QMUINavigationButton barButtonItemWithNavigationButton:btn position:(QMUINavigationButtonPositionLeft) target:self action:@selector(backButtonDidClick:)];
                self.navigationItem.leftBarButtonItem = backItem;
        }
        else
        {
                self.navigationItem.leftBarButtonItems = nil;
                self.navigationItem.leftBarButtonItem = nil;
        }
        navigationBar.translucent = NO;
        [self.navigationController.navigationBar setTranslucent:NO];
}

- (BOOL)forceEnableNavigationBarBackItem
{
        return NO;
}

- (UIImage *)navigationBarBackItemImage
{
        return [UIImage nav_ic_back_blackRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
}

- (void)postReloadDataNotifaction
{
        NSNotification *noti = [[NSNotification alloc] initWithName:WGViewControllerReloadDataNotifaction object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
}
- (void)backButtonDidClick:(UIButton *)button
{
        if (self.isPresentedByOther) {
                [self dismissViewControllerAnimated:YES completion:self.dismissBlock];
        } else if (self.navigationController.viewControllers.count == 1 && self.navigationController.isPresentedByOther) {
                [self.navigationController dismissViewControllerAnimated:YES completion:self.dismissBlock];
        } else {
                [self.navigationController popViewControllerAnimated:YES];
                if (self.dismissBlock) {
                        self.dismissBlock();
                }
        }
        
}

+ (__kindof BaseControllerView * _Nullable)controllerView
{
        return nil;
}

+ (WGControllerAnimationType)transitionAnimationType
{
        return WGControllerAnimationTypeDefault;
}
+ (WGControllerInteractionType)interactionType
{
        return WGControllerInteractionTypeNone;
}
/// RouterHandleProtocol method
- (void)routeUrl:(NSString *)url param:(NSDictionary *)param
{
        [self routeUrl:url param:param handler:nil];
}
- (void)routeUrl:(NSString *)url param:(NSDictionary *)param handler:(__nullable RouterServiceCallBackBlock)handlerBlock
{
        @weakify(self);
        [AppShareRouterService routeURL:[NSURL URLWithString:url]
                          withParamters:param
                                handler:^(NSDictionary<NSString *,id> * _Nullable parameters, UIViewController<JLRRouteDefinitionTargetController> * _Nullable targetVC) {
                                        @strongify(self);
                                        if (handlerBlock)
                                        {
                                                handlerBlock(parameters,targetVC);
                                        }
                                        else
                                        {
                                                if (targetVC)
                                                {
                                                        if (self.navigationController)
                                                        {
                                                                [self.navigationController pushViewController:targetVC animated:YES];
                                                        }
                                                        else
                                                        {
                                                                BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:targetVC];
                                                                [self presentViewController:nav animated:YES completion:nil];
                                                        }
                                                }
                                                else
                                                {
                                                        [MLSTipClass showText:[NSString app_NeworkError]];
                                                }
                                        }
                                }];
}
+ (nullable UIViewController <JLRRouteDefinitionTargetController> *)targetControllerWithParams:(nullable NSDictionary *)parameters
{
        return [[self alloc] init];
}
- (void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:WGViewControllerReloadDataNotifaction object:nil];
//#if DEBUG
//        [MLSTipClass showText:[NSString stringWithFormat:@"------ %@ ------- dealloc",[self className]]];
//#endif
        NSLogDebug(@"-------%@ dealloc -------",self);
}

@end

@implementation BaseViewController (Comment)
- (void)initCommentView
{
        self.commentToolBar = [self getCommentView];
        BaseCommentToolBarType type = [self commentToolBarType];
        BOOL hasEmotion = (type == BaseCommentToolBarTypeEmotion || type == BaseCommentToolBarTypeEmotionAutoHeight);
        if (!self.commentToolBar && type != BaseCommentToolBarTypeNone)
        {
                self.commentToolBar = [[BaseCommentToolBar alloc] initWithEmotion:hasEmotion];
                
                [self.commentToolBar setAutoResizable:(type == BaseCommentToolBarTypeAutoHeight || type == BaseCommentToolBarTypeEmotionAutoHeight)];
        }
        if (!self.commentToolBar)
        {
                return;
        }
        [IQKeyboardManager.sharedManager.disabledDistanceHandlingClasses addObject:[self class]];
        self.commentToolBar.delegate = self;
        [self.commentToolBar setPlaceHolder:[self placeHolderString]];
        [self.commentToolBar setPlaceHolder:[self placeHolderAttributeString]];
        @weakify(self);
        [self.commentToolBar setToolBarActionBlock:^(BaseCommentToolBarActionType type, id<BaseCommentToolBarProtocol> tooBar) {
                @strongify(self);
                if (type == BaseCommentToolBarActionTypeShowEmotion)
                {
                        [self showEmotionView];
                }
                else if (type == BaseCommentToolBarActionTypeHideEmotion)
                {
                        [self.commentToolBar.realTextView becomeFirstResponder];
                }
                else if (type == BaseCommentToolBarActionTypeSend)
                {
                        [self commentViewSendButtonDidClick:self.commentToolBar hideBlock:^(BOOL hide) {
                                if (hide) {
                                        [self hide];
                                }
                        } cleanTextBlock:^(BOOL clean) {
                                if (clean) {
                                        self.commentToolBar.realTextView.text = nil;
                                }
                        }];
                }
                else if (type == BaseCommentToolBarActionTypeTextNotValid)
                {
//                        [MLSTipClass showText:[NSString app_CommentSaySomeThingFuny] inView:self.view];
                }
        }];
        
        self.maskControl = [[UIControl alloc] init];
        self.maskControl.backgroundColor = UIColorMask;
        self.maskControl.alpha = 0;
        
        if (hasEmotion)
        {
                self.qqEmotionManager = [[QMUIEmotionInputManager alloc] init];
                if ([self.commentToolBar.realTextView isKindOfClass:[UITextField class]])
                {
                        self.qqEmotionManager.boundTextField = (UITextField *)self.commentToolBar.realTextView;
                }
                else if ([self.commentToolBar.realTextView isKindOfClass:[UITextView class]])
                {
                        self.qqEmotionManager.boundTextView = (UITextView *)self.commentToolBar.realTextView;
                }
                self.qqEmotionManager.emotionView.qmui_borderPosition = QMUIBorderViewPositionTop;
                [self.view addSubview:self.qqEmotionManager.emotionView];
                [self.qqEmotionManager.emotionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        if (@available(iOS 11.0,*))
                        {
                                make.top.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                                make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
                                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
                        }
                        else
                        {
                                make.top.equalTo(self.view.mas_bottom);
                                make.left.right.equalTo(self.view);
                        }
                        make.height.mas_equalTo(kEmotionViewHeight);
                }];
        }
        [self.commentToolBar setEmotionManager:self.qqEmotionManager];
        [self.commentToolBar.realTextView setValidator:[self validator]];
        
        [self.maskControl jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                @strongify(self);
                [self hideCommentViewWithCleanText:NO force:YES];
        }];
        
        [self.view addSubview:self.maskControl];
        [self.maskControl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
        }];
        
        [self.view addSubview:self.commentToolBar];
        
        [self.commentToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
                if ([self alwaysShowCommentView])
                {
                        if (@available(iOS 11.0,*))
                        {
                                make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
                                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
                                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                        }
                        else
                        {
                                make.left.right.equalTo(self.view);
                                make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
                        }
                }
                else
                {
                        make.top.equalTo(self.view.mas_bottom);
                        make.left.right.equalTo(self.view);
                }
        }];
        
        self.keyboardManager = [[QMUIKeyboardManager alloc] initWithDelegate:self];
        [self.keyboardManager addTargetResponder:self.commentToolBar.realTextView];
}
/// MARK: -键盘事件 处理
- (void)keyboardWillChangeFrameWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
        if (!self.commentToolBar.isShowingEmotion)
        {
                @weakify(self);
                [QMUIKeyboardManager handleKeyboardNotificationWithUserInfo:keyboardUserInfo showBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
                        @strongify(self);
                        [self showToolbarViewWithKeyboardUserInfo:keyboardUserInfo];
                } hideBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
                        @strongify(self);
                        [self hideToolbarViewWithKeyboardUserInfo:keyboardUserInfo];
                }];
        }
        else
        {
                [self showToolbarViewWithKeyboardUserInfo:nil];
        }
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
        if (view == self.commentToolBar) {
                // 输入框并非撑满 toolbarView 的，所以有可能点击到 toolbarView 里空白的地方，此时保持键盘状态不变
                return NO;
        }
        return YES;
}

- (void)showEmotionView {
        [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
                self.qqEmotionManager.emotionView.layer.transform = CATransform3DMakeTranslation(0, - CGRectGetHeight(self.qqEmotionManager.emotionView.bounds), 0);
        } completion:NULL];
        [self.commentToolBar.realTextView resignFirstResponder];
        [self showToolbarViewWithKeyboardUserInfo:nil];
}
- (void)showToolbarViewWithKeyboardUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo
{
        [self.commentToolBar setPlaceHolder:[self placeHolderAttributeString]];
        [self.commentToolBar setPlaceHolder:[self placeHolderString]];
        if (keyboardUserInfo) {
                // 相对于键盘
                [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
                        self.maskControl.alpha = 1;
                        CGFloat distanceFromBottom = [QMUIKeyboardManager distanceFromMinYToBottomInView:self.view keyboardRect:keyboardUserInfo.endFrame];
                        CGFloat toobarHeight = CGRectGetHeight(self.commentToolBar.bounds);
                        if ([self alwaysShowCommentView])
                        {
                                toobarHeight = 0;
                        }
                        self.commentToolBar.layer.transform = CATransform3DMakeTranslation(0, - distanceFromBottom - toobarHeight, 0);
                        self.qqEmotionManager.emotionView.layer.transform = CATransform3DMakeTranslation(0, -distanceFromBottom, 0);
                } completion:^(BOOL finished) {
                        [self commentViewDidShow:self.commentToolBar];
                }];
        } else {
                // 相对于表情面板
                [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
                        self.maskControl.alpha = 1;
                        CGFloat toobarHeight = CGRectGetHeight(self.commentToolBar.bounds);
                        if ([self alwaysShowCommentView])
                        {
                                toobarHeight = 0;
                        }
                        self.commentToolBar.layer.transform = CATransform3DMakeTranslation(0, - CGRectGetHeight(self.qqEmotionManager.emotionView.bounds) - toobarHeight, 0);
                } completion:^(BOOL finished) {
                        [self commentViewDidShow:self.commentToolBar];
                }];
        }
}

- (void)hideToolbarViewWithKeyboardUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
        if (keyboardUserInfo) {
                [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
                        self.commentToolBar.layer.transform = CATransform3DIdentity;
                        self.qqEmotionManager.emotionView.layer.transform = CATransform3DIdentity;
                        self.maskControl.alpha = 0;
                } completion:^(BOOL finished) {
                        [self commentViewDidHide:self.commentToolBar];
                }];
        } else {
                [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
                        self.commentToolBar.layer.transform = CATransform3DIdentity;
                        self.qqEmotionManager.emotionView.layer.transform = CATransform3DIdentity;
                        self.maskControl.alpha = 0;
                } completion:^(BOOL finished) {
                        [self commentViewDidHide:self.commentToolBar];
                }];
        }
}
- (void)hide
{
        [self.commentToolBar.realTextView resignFirstResponder];
        [self hideToolbarViewWithKeyboardUserInfo:nil];
}
/// MARK: - CommentToolBar 代理
- (BOOL)commentToolBarWillHide:(UIView<BaseCommentToolBarProtocol> *)commentTooBar
{
        return [self commentViewWillHide:commentTooBar];
}
- (BOOL)commentToolBarWillShow:(UIView<BaseCommentToolBarProtocol> *)commentTooBar
{
        return [self commentViewWillShow:commentTooBar];
}

/// MARK: - SubClass Holder
- (UIView <BaseCommentToolBarProtocol>*)getCommentView
{
        return nil;
}
- (id<US2ValidatorUIProtocol>)textView
{
        return nil;
}
- (US2Validator *)validator
{
        US2ValidatorRange *rangeValidator = [[US2ValidatorRange alloc] initWithRange:NSMakeRange(1, 70)];
        return rangeValidator;
}
- (BOOL)alwaysShowCommentView
{
        return NO;
}
- (CGFloat)expandMaxHeight
{
        return 300;
}
- (BOOL)autoExpandHeight
{
        return NO;
}

- (NSString *)placeHolderString
{
        return [NSString app_CommentSaySomeThingFuny];
}

- (NSAttributedString *)placeHolderAttributeString
{
        return nil;
}

- (BaseCommentToolBarType)commentToolBarType
{
        return BaseCommentToolBarTypeNone;
}
- (BOOL)commentViewWillShow:(id <BaseCommentToolBarProtocol>)commentView
{
        return YES;
}
- (void)commentViewDidShow:(id <BaseCommentToolBarProtocol>)commentView
{
        
}

- (BOOL)commentViewWillHide:(id <BaseCommentToolBarProtocol>)commentView
{
        return YES;
}

- (void)commentViewDidHide:(id <BaseCommentToolBarProtocol>)commentView
{
        
}

- (void)commentViewSendButtonDidClick:(id <BaseCommentToolBarProtocol>)commentView hideBlock:(void (^)(BOOL hide))hideBlock cleanTextBlock:(void (^)(BOOL clean))cleanTextBlock
{
        hideBlock(YES);
        cleanTextBlock(YES);
}

- (void)showCommentViewWithCleanText:(BOOL)cleanText
{
        [self.commentToolBar.realTextView becomeFirstResponder];
        self.maskControl.hidden = NO;
        if (cleanText) {
                self.commentToolBar.realTextView.text = nil;
        }
}

- (void)hideCommentViewWithCleanText:(BOOL)cleanText force:(BOOL)force
{
        [self.commentToolBar.realTextView resignFirstResponder];
        if (cleanText) {
                self.commentToolBar.realTextView.text = nil;
        }
}
- (BOOL)commentForceLayoutBringToTop
{
        return NO;
}


@end

NSString *WGViewControllerReloadDataNotifaction = @"WGViewControllerReloadDataNotifaction";
