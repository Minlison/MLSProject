//
//  MLSModifyInfoViewController.m
//  MLSProject
//
//  Created by MinLison on 2017/12/11.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSModifyInfoViewController.h"
#import "MLSUpdateUserInfoRequest.h"
@interface MLSModifyInfoViewController ()
@property(nonatomic, strong) UIButton *saveButton;
@end

@implementation MLSModifyInfoViewController

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.title = [NSString stringWithFormat:@"%@",self.rowDescriptor.title];
        self.fd_interactivePopDisabled = YES;
        self.controllerView.rowDescriptor = self.rowDescriptor;
}
- (void)initSubviews
{
        [super initSubviews];
        @weakify(self);
        [self.controllerView setValidatorAction:^(BOOL validator) {
                @strongify(self);
                self.saveButton.enabled = validator;
        }];
}
- (void)configNavigationBar:(BaseNavigationBar *)navigationBar
{
        [super configNavigationBar:navigationBar];
        QMUIButton *button = [[QMUIButton alloc] qmui_initWithImage:nil title:@"保存"];
        [button setTitleColor:UIColorHex(0x070808) forState:(UIControlStateNormal)];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        button.titleLabel.font = WGSystem16Font;
        button.frame = CGRectMake(0, 0, 80, 50);
        [button addTarget:self action:@selector(saveItemDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
        self.saveButton = button;
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = saveItem;
}
- (void)saveItemDidClick:(QMUINavigationButton *)btn
{
        if (self.controllerView.isValidator) {
                [self updateUserInfo];
        } else {
                [MLSTipClass showText:[NSString stringWithFormat:@"请输入正确%@",self.rowDescriptor.title] inView:self.view];
        }
}

- (void)updateUserInfo
{
        [MLSTipClass showLoadingInView:self.view];
        @weakify(self);
        [MLSUserManager updateUserInfoWithParam:@{
                                                 self.rowDescriptor.tag : self.rowDescriptor.value,
                                                 } success:^(NSString * _Nonnull sms) {
                                                         @strongify(self);
                                                         [MLSTipClass hideLoadingInView:self.view];
                                                         [MLSTipClass showText:[NSString stringWithFormat:@"%@修改成功",self.rowDescriptor.title]];
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                 } failed:^(NSError * _Nonnull error) {
                                                         @strongify(self);
                                                         [MLSTipClass showErrorWithText:error.localizedDescription inView:self.view];
                                                 }];
}


@end
