//
//  MLSUserLoginViewController.m
//  MinLison
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSPopLoginViewController.h"
#import "STPopup.h"
#import "MLSFormLoginViewController.h"
@interface MLSPopLoginViewController ()
@property(nonatomic, strong) TTTAttributedLabel *titleLabel;
@property(nonatomic, strong) QMUIButton *webCatView;
@property(nonatomic, strong) QMUIButton *qqView;
@property(nonatomic, strong) QMUIButton *weiBoView;
@property(nonatomic, strong) QMUIButton *phoneView;
@property(nonatomic, strong) QMUIButton *loginButton;
@property(nonatomic, strong) QMUIButton *registerButton;
@property(nonatomic, assign) WGPopLoginType popLoginType;
@property(nonatomic, weak) UIViewController *presentInVC;
@end

@implementation MLSPopLoginViewController

- (instancetype)initWithType:(WGPopLoginType)type
{
        if (self = [super init]) {
                self.popLoginType = type;
                [self _InitContentSizeWithType:type];
        }
        return self;
}
- (void)_InitContentSizeWithType:(WGPopLoginType)type
{
        switch (type) {
                case WGPopLoginTypeFormSheet:
                {
                        CGFloat w = 304.0 / 375.0  * __MAIN_SCREEN_WIDTH__;
                        CGFloat h = w * (192.0 / 304.0);
                        self.contentSizeInPopup = CGSizeMake(w,h);
                        self.landscapeContentSizeInPopup = CGSizeMake(w,h);
                }
                        break;
                case WGPopLoginTypeBottomSheet:
                {
                        CGFloat w = __MAIN_SCREEN_WIDTH__;
                        CGFloat h = w * (176.0 / 375.0);
                        self.contentSizeInPopup = CGSizeMake(w,h);
                        self.landscapeContentSizeInPopup = CGSizeMake(w,h);
                }
                        break;
                        
                default:
                        break;
        }
}
- (void)viewDidLoad
{
        [super viewDidLoad];
        self.view.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
        [self _LayoutViews];
        @weakify(self);
        [self.KVOController observe:LNUserManager keyPath:@keypath(LNUserManager,login) options:(NSKeyValueObservingOptionNew) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                @strongify(self);
                if (LNUserManager.isLogin && !LNUserManager.is_new_user)
                {
                        [self.popupController dismiss];
                }
        }];
}
- (void)applicationDidBecomeActive
{
        if (!self.firstAppear)
        {
                [self.popupController dismiss];
        }
}

- (void)presentInViewController:(UIViewController *)viewController completion:(void (^)(void))completion dismiss:(void (^)(void))dismiss
{
        self.presentInVC = viewController ?:__KEY_WINDOW__.rootViewController;
        [[self getPopUpControllerWithDismiss:dismiss] presentInViewController:self.presentInVC completion:completion];
}
- (STPopupController *)getPopUpControllerWithDismiss:(void (^)(void))dismiss
{
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self];
        switch (self.popLoginType) {
                case WGPopLoginTypeFormSheet:
                {
                        popupController.containerView.layer.cornerRadius = 12;
                }
                        break;
                case WGPopLoginTypeBottomSheet:
                {
                        popupController.containerView.layer.cornerRadius = 0;
                }
                        break;
                        
                default:
                        break;
        }
        
        popupController.navigationBarHidden = YES;
        popupController.style = STPopupStyleBottomSheet;
        popupController.DissmissCallBack = ^{
                if (dismiss) {
                        dismiss();
                }
        };
        return popupController;
}

- (void)_LayoutViews
{
        [self.view addSubview:self.titleLabel];
        
        UIStackView *thridStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.webCatView,self.qqView,self.phoneView]];
        thridStackView.axis = UILayoutConstraintAxisHorizontal;
        thridStackView.distribution = UIStackViewDistributionFillEqually;
        thridStackView.alignment = UIStackViewAlignmentFill;
        thridStackView.spacing = 59;
        
        
//        UIView *lineView = [[UIView alloc] init];
//        lineView.backgroundColor = UIColorGray1;
//        UIStackView *loginRegisterStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.loginButton,self.registerButton]];
//        loginRegisterStackView.axis = UILayoutConstraintAxisHorizontal;
//        loginRegisterStackView.distribution = UIStackViewDistributionFillEqually;
//        loginRegisterStackView.alignment = UIStackViewAlignmentFill;
//        loginRegisterStackView.spacing = 0;
//        loginRegisterStackView.tintColor = [UIColor clearColor];
        
        [self.view addSubview:thridStackView];
//        [self.view addSubview:loginRegisterStackView];
//        [self.view addSubview:lineView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).offset(__WGHeight(15));
                make.centerX.equalTo(self.view.mas_centerX);
        }];
        
        [thridStackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.greaterThanOrEqualTo(self.titleLabel.mas_bottom).offset(__WGWidth(28));
                make.centerX.equalTo(self.view);
                make.leading.greaterThanOrEqualTo(self.view).offset(__WGWidth(8));
                make.trailing.lessThanOrEqualTo(self.view).offset(-__WGWidth(8));
                make.height.mas_equalTo(__WGWidth(52.0));
                make.bottom.equalTo(self.view).offset(-__WGHeight(60));
        }];
        
//        [loginRegisterStackView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(thridStackView.mas_bottom).offset(32);
//                make.leading.trailing.equalTo(self.view);
//                make.height.mas_equalTo((48.0 / 375.0 * __MAIN_SCREEN_WIDTH__));
//                make.bottom.equalTo(self.view);
//        }];
//
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(0.5);
//                make.top.equalTo(loginRegisterStackView.mas_top);
//                make.bottom.equalTo(loginRegisterStackView.mas_bottom);
//                make.centerX.equalTo(loginRegisterStackView);
//        }];
}

- (void)registerButtonClick:(UIButton *)button
{
}
- (void)loginButtonClick:(UIButton *)button
{
        UIViewController *vc = self.presentInVC ?:__KEY_WINDOW__.rootViewController;
        MLSFormLoginViewController *logRegVC = [[MLSFormLoginViewController alloc] init];
        [vc presentViewController:[[BaseNavigationViewController alloc] initWithRootViewController:logRegVC] animated:YES completion:^{
                [self.popupController dismiss];
        }];
}
- (void)threePartiesLogin:(UIButton *)sender
{
        [LNUserManager loginType:(LNLoginType)sender.tag param:nil success:^(MLSUserModel * _Nonnull user) {
                [MLSTipClass showText:[NSString app_AuthorizationSuccess]];
                [self.popupController dismiss];
        } failed:^(NSError * _Nonnull error) {
                [MLSTipClass showText:error.localizedDescription];
                [self.popupController dismiss];
        }];
}
- (TTTAttributedLabel *)titleLabel
{
        if (_titleLabel == nil) {
                _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _titleLabel.text = [NSString app_Login];
                _titleLabel.textColor  = UIColorHex(0x606060);
                _titleLabel.font = WGSystem16Font;
        }
        return _titleLabel;
}

- (QMUIButton *)webCatView
{
        if (_webCatView == nil) {
                _webCatView = [QMUIButton buttonWithType:(UIButtonTypeCustom)];
                [_webCatView setImage:[UIImage login_icon_wechat] forState:(UIControlStateNormal)];
                _webCatView.imageView.contentMode = UIViewContentModeScaleAspectFit;
                _webCatView.tag = LNLoginTypeWebchat;
                [_webCatView addTarget:self action:@selector(threePartiesLogin:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        return _webCatView;
}
- (QMUIButton *)qqView
{
        if (_qqView == nil) {
                _qqView = [QMUIButton buttonWithType:(UIButtonTypeCustom)];
                [_qqView setImage:[UIImage login_icon_qq] forState:(UIControlStateNormal)];
                _qqView.imageView.contentMode = UIViewContentModeScaleAspectFit;
                _qqView.tag = LNLoginTypeQQ;
                [_qqView addTarget:self action:@selector(threePartiesLogin:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        return _qqView;
}
- (QMUIButton *)weiBoView
{
        if (_weiBoView == nil) {
                _weiBoView = [QMUIButton buttonWithType:(UIButtonTypeCustom)];
                [_weiBoView setImage:[UIImage login_icon_weibo] forState:(UIControlStateNormal)];
                _weiBoView.imageView.contentMode = UIViewContentModeScaleAspectFit;
                _weiBoView.tag = LNLoginTypeWeibo;
                [_weiBoView addTarget:self action:@selector(threePartiesLogin:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        return _weiBoView;
}
- (QMUIButton *)phoneView
{
        if (_phoneView == nil) {
                _phoneView = [QMUIButton buttonWithType:(UIButtonTypeCustom)];
                _phoneView.tag = LNLoginTypePhone;
                [_phoneView setImage:[UIImage login_icon_phone] forState:(UIControlStateNormal)];
                _phoneView.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [_phoneView addTarget:self action:@selector(loginButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        return _phoneView;
}
- (QMUIButton *)registerButton
{
        if (_registerButton == nil) {
                _registerButton = [QMUIButton buttonWithType:(UIButtonTypeCustom)];
                _registerButton.backgroundColor = UIColorWhite;
                _registerButton.titleLabel.font = WGSystem14Font;
                [_registerButton setTitle:@"注册" forState:(UIControlStateNormal)];
                [_registerButton setTitleColor:UIColorGray1 forState:UIControlStateNormal];
                _registerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                [_registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        return _registerButton;
}
- (QMUIButton *)loginButton
{
        if (_loginButton == nil) {
                _loginButton = [QMUIButton buttonWithType:(UIButtonTypeCustom)];
                _loginButton.backgroundColor = UIColorWhite;
                _loginButton.titleLabel.font = WGSystem14Font;
                [_loginButton setTitle:@"手机" forState:(UIControlStateNormal)];
                [_loginButton setTitleColor:UIColorGray1 forState:UIControlStateNormal];
                _loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        return _loginButton;
}
@end
