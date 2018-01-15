//
//  MLSSetPwdView.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSSetPwdView.h"
#import "MLSUserSetPwdForm.h"
@interface MLSSetPwdView ()
@end
@implementation MLSSetPwdView

- (void)setupTableView
{
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
