//
//  MLSMineSettingViewController.m
//  MLSProject
//
//  Created by MinLison on 2017/12/8.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSMineSettingViewController.h"
#import "MLSSettingForm.h"
@interface MLSMineSettingViewController ()

@end

@implementation MLSMineSettingViewController

- (void)configNavigationBar:(BaseNavigationBar *)navigationBar
{
        [super configNavigationBar:navigationBar];
        self.title = @"设置";
}

- (void)initSubviews
{
        [super initSubviews];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorHex(0xf5f5f5);
        self.form = [[MLSSettingForm alloc] init];
        
        @weakify(self);
        [self.controllerView.logoutButton.actionButton jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                [MLSUserManager logOut:nil success:^(NSString * _Nonnull sms) {
                        [MLSTipClass showText:sms];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                } failed:^(NSError * _Nonnull error) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                }];
        }];
}

@end
