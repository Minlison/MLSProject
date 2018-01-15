//
//  MLSSetPwdViewController.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSSetPwdViewController.h"
#import "MLSRegisterNotNewUserViewController.h"
@interface MLSSetPwdViewController ()<FXFormControllerDelegate>
@property(nonatomic, strong) FXFormController *formController;
@property(nonatomic, strong) MLSUserSetPwdForm *form;
@end

@implementation MLSSetPwdViewController

- (void)viewDidLoad
{
        [super viewDidLoad];
        
}
- (void)configForm
{
        self.form = [[MLSUserSetPwdForm alloc] initWithType:self.type];
        self.formController = [[FXFormController alloc] init];
        self.formController.form = self.form;
        self.formController.delegate = self;
        self.formController.tableView = self.tableView;
}

- (void)configNavigationBar:(BaseNavigationBar *)navigationBar
{
        [super configNavigationBar:navigationBar];
        self.titleView.titleLabel.textColor = [UIColor whiteColor];
        switch (self.type)
        {
                case LNSetPwdTypeRegister:
                {
                        self.title = @"注册";
                }
                        break;
                case LNSetPwdTypeFindPwd:
                {
                        self.title = @"忘记密码";
                }
                        break;
                        
                default:
                        break;
        }
        
}
- (void)initSubviews
{
        [super initSubviews];
        [self configForm];
}
/// MARK: - Action
- (void)next
{
        switch (self.type)
        {
                case LNSetPwdTypeRegister:
                {
                        [self registerToSetPwd];
                }
                        break;
                case LNSetPwdTypeFindPwd:
                {
                        [self findPwdToSetPwd];
                }
                        break;
                        
                default:
                        break;
        }
        
}
- (void)registerToSetPwd
{
        [LNUserManager registerWithParam:@{
                                           kRequestKeyPassword : self.form.password
                                           } success:^(MLSUserModel * _Nonnull user) {
                 [self successSetPwd];
         } failed:^(NSError * _Nonnull error) {
                 [self failedSetPwd:error];
         }];
}

- (void)findPwdToSetPwd
{
        [LNUserManager findPwd:nil success:^(MLSUserModel * _Nonnull user) {
                [self successSetPwd];
        } failed:^(NSError * _Nonnull error) {
                [self failedSetPwd:error];
        }];
}
- (void)successSetPwd
{
        if (!LNUserManager.isUserInfoComplete)
        {
                @weakify(self);
                [self routeUrl:kLNUpdateUserInfoControllerURI param:nil handler:^(NSDictionary<NSString *,id> * _Nullable parameters, UIViewController<JLRRouteDefinitionTargetController> * _Nullable targetVC) {
                        @strongify(self);
                        NSMutableArray *array = [NSMutableArray array];
                        [array addObject:self.navigationController.viewControllers.firstObject];
                        [array addObject:targetVC];
                        [self.navigationController setViewControllers:array animated:YES];
                }];
        }
        else
        {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
        }
}
- (void)failedSetPwd:(NSError * )error
{
        if (error.code == APP_ERROR_CODE_ERR_PHONE_ALLREADY_REGISTER)
        {
                MLSRegisterNotNewUserViewController *vc = [[MLSRegisterNotNewUserViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
                [MLSTipClass showErrorWithText:error.localizedDescription inView:self.view];
        }
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
