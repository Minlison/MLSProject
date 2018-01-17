//
//  MLSFormLoginViewController.m
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSFormLoginViewController.h"
#import "MLSGetCountryCodeViewController.h"
#import "MLSUpdateUserInfoViewController.h"
#import "MLSUserLoginForm.h"
#import "MLSRegisterViewController.h"
#import "MLSFindPwdViewController.h"

@interface MLSFormLoginViewController ()
@property (nonatomic, strong) FXFormController *formController;
@property (nonatomic,strong) QMUIButton *rightNavButton;
@end

@implementation MLSFormLoginViewController
- (void)presentOrPushInViewController:(UIViewController *)viewController
{
        if (viewController.navigationController)
        {
                [viewController.navigationController pushViewController:self animated:YES];
        }
        else
        {
                BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:self];
                [viewController presentViewController:nav animated:YES completion:nil];
        }
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        MLSUserManager.country_code = @"86";
        @weakify(self);
        
        self.controllerView.actionBlock = ^(MLSFormLoginViewClickType clickType, MLSLoginType type, NSDictionary * _Nullable param, MLSUserStringActionBlock  _Nullable contryCode) {
                @strongify(self);
                switch (clickType)
                {
                        case MLSFormLoginViewClickTypeGetSmsCode:
                        {
                                [self getSMSCodeParams:param];
                        }
                                break;
                        case MLSFormLoginViewClickTypeLoginClick:
                        case MLSFormLoginViewClickTypeThirdLoginClick:
                        {
                                [self loginType:type params:param];
                        }
                                break;
                        
                        case MLSFormLoginViewClickTypeGetCountryCode:
                        {
                                [self getCountryCode:contryCode];
                        }
                                break;
                        case MLSFormLoginViewClickTypeFindPwd:
                        {
                                [self findPwd];
                        }
                                break;
                                
                        default:
                                break;
                }
        };
}

- (void)registerItemDidClick:(QMUIButton *)btn
{
        MLSRegisterViewController *vc = [[MLSRegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
}
- (void)configNavigationBar:(BaseNavigationBar *)navigationBar
{
        [super configNavigationBar:navigationBar];
        self.titleView.titleLabel.textColor = [UIColor whiteColor];
        self.title = @"登录";
        //右侧刷新Item
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavButton];
        self.navigationItem.rightBarButtonItem = rightItem;
}
//自定义右侧Item
-(QMUIButton *)rightNavButton
{
        if (_rightNavButton == nil) {
                _rightNavButton = [[QMUIButton alloc] qmui_initWithImage:nil title:@"注册"];
                [_rightNavButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                _rightNavButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                _rightNavButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
                _rightNavButton.titleLabel.font = WGSystem16Font;
                _rightNavButton.frame = CGRectMake(0, 0, 80, 50);
                [_rightNavButton addTarget:self action:@selector(registerItemDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        return _rightNavButton;
}
/// MARK: - Form
- (void)loginType:(MLSLoginType)type params:(NSDictionary *)params
{
        [MLSUserManager loginType:type param:params success:^(MLSUserModel * _Nonnull user) {
                [MLSTipClass showText:[NSString aPP_LoginSuccess]];
                [self loginSuccess];
        } failed:^(NSError * _Nonnull error) {
                [MLSTipClass showText:error.localizedDescription inView:self.view];
        }];
}
- (void)loginSuccess
{
        if (!MLSUserManager.isUserInfoComplete)
        {
                @weakify(self);
                [self routeUrl:kMLSUpdateUserInfoControllerURI param:nil handler:^(NSDictionary<NSString *,id> * _Nullable parameters, UIViewController<JLRRouteDefinitionTargetController> * _Nullable targetVC) {
                        @strongify(self);
                        NSMutableArray *array = [NSMutableArray array];
                        [array addObject:self.navigationController.viewControllers.firstObject];
                        [array addObject:targetVC];
                        [self.navigationController setViewControllers:array animated:YES];
                }];
        }
        else
        {
                if (self.dismissBlock) {
                        self.dismissBlock();
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
        }
}
- (void)findPwd
{
        MLSFindPwdViewController *vc = [[MLSFindPwdViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
}
- (void)getSMSCodeParams:(NSDictionary *)params
{
        [MLSUserManager getSMSWithParam:params success:^(NSString * _Nonnull sms) {
                
                [MLSTipClass showText:sms inView:self.view];
                
        } failed:^(NSError * _Nonnull error) {
                [MLSTipClass showText:error.localizedDescription inView:self.view];
        }];
}
- (void)getCountryCode:(MLSUserStringActionBlock)contryCodeBlock
{
        MLSGetCountryCodeViewController *vc = [[MLSGetCountryCodeViewController alloc] init];
        [vc setGetCountryCodeBlock:^(NSString *countryCode) {
                if (contryCodeBlock)
                {
                        contryCodeBlock(countryCode);
                }
        }];
        [self.navigationController pushViewController:vc animated:YES];
}
/// MARK: - 导航栏 SubClassHolder
- (BOOL)forceEnableNavigationBarBackItem
{
        return YES;
}
- (UIImage *)navigationBarBackItemImage
{
        return [UIImage nav_ic_back_whiteRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
}
- (UIImage *)navigationBarBackgroundImage
{
        return [UIImage imageWithColor:UIColorHex(0x0190D4)];
}
- (UIColor *)navigationBarTintColor
{
        return [UIColor whiteColor];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
        return UIStatusBarStyleLightContent;
}
@end
