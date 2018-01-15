//
//  MLSMineViewController.m
//  MLSProject
//
//  Created by MinLison on 2017/11/30.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSMineViewController.h"
#import "XLFormViewController.h"
#import "MLSMineForm.h"
@interface MLSMineViewController ()
@end

@implementation MLSMineViewController
- (void)viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
}
- (void)initSubviews
{
        [super initSubviews];
        self.fd_prefersNavigationBarHidden = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorHex(0xf5f5f5);
        self.form = [[MLSMineForm alloc] init];
        @weakify(self);
        [self.controllerView setActionBlock:^(LNMineViewClickType type) {
                @strongify(self);
                [self pushToUpdateUserInfoLogInIfNeed];
        }];
}

- (void)pushToUpdateUserInfoLogInIfNeed
{
        if (LNUserManager.isLogin)
        {
                [LNUserManager pushOrPresentUserInfoInViewController:self completion:nil dismiss:nil];
        }
        else
        {
                [LNUserManager pushOrPresentLoginIfNeed:YES inViewController:self completion:nil dismiss:nil];
        }
}
- (BOOL)preferredNavigationBarHidden
{
        return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
        return UIStatusBarStyleLightContent;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        if (section == 1)
        {
                return __WGHeight(15);
        }
        return CGFLOAT_MIN;
}

@end
