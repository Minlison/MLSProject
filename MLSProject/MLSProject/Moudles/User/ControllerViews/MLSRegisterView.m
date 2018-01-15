//
//  MLSRegisterView.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSRegisterView.h"
#import "MLSUserRegisterForm.h"
@interface MLSRegisterView ()
@property (nonatomic, strong) FXFormController *formController;
@end
@implementation MLSRegisterView

- (void)configForm
{
        self.formController = [[FXFormController alloc] init];
        self.formController.form = [[MLSUserRegisterForm alloc] init];
        self.formController.delegate = (id<FXFormControllerDelegate>)self.controller;
        self.formController.tableView = self.tableView;
}

- (void)setupTableView
{
        [self configForm];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.bounces = NO;
        
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MAIN_SCREEN_WIDTH__, __WGHeight(40))];
        self.tableView.tableHeaderView = tableHeaderView;
        [tableHeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(__WGWidth(40));
                make.width.equalTo(self.tableView);
        }];
        self.tableView.tableHeaderView = tableHeaderView;
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                if (@available(iOS 11.0, *))
                {
                        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
                        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
                        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
                        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
                }
                else
                {
                        make.top.left.bottom.right.equalTo(self);
                }
        }];
        
}

@end
