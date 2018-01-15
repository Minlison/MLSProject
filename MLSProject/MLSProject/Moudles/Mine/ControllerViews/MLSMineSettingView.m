//
//  MLSMineSettingView.m
//  MLSProject
//
//  Created by MinLison on 2017/12/8.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSMineSettingView.h"
@interface MLSMineSettingView ()
@property(nonatomic, strong, readwrite) MLSCommonBottomView *logoutButton;
@end
@implementation MLSMineSettingView

- (void)setupTableView
{
        [self addSubview:self.logoutButton];
        self.tableView.backgroundColor = UIColorHex(0xf5f5f5);
        BOOL showComment = [self.controller alwaysShowCommentView];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                if (@available(iOS 11.0,*))
                {
                        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
                        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
                        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
                }
                else
                {
                        make.top.equalTo(self.controller.mas_topLayoutGuideBottom);
                        make.left.right.equalTo(self);
                }
        }];
        [self.logoutButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11.0,*))
                {
                        if (showComment)
                        {
                                make.bottom.equalTo(self.controller.commentToolBar.mas_safeAreaLayoutGuideTop);
                        }
                        else
                        {
                                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
                        }
                        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
                        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
                }
                else
                {
                        if (showComment)
                        {
                                make.bottom.equalTo(self.controller.commentToolBar.mas_top);
                        }
                        else
                        {
                                make.bottom.equalTo(self.controller.mas_bottomLayoutGuideTop);
                        }
                        make.left.right.equalTo(self);
                }
                
                make.top.equalTo(self.tableView.mas_bottom);
                make.height.mas_equalTo(__WGHeight(61));
        }];
}


- (MLSCommonBottomView *)logoutButton
{
        if (_logoutButton == nil) {
                _logoutButton = [[MLSCommonBottomView alloc] init];
                [_logoutButton.actionButton setTitle:@"退出登录" forState:(UIControlStateNormal)];
                _logoutButton.qmui_borderPosition = QMUIBorderViewPositionTop;
                _logoutButton.qmui_borderColor = UIColorHex(0xE6E6E6);
                _logoutButton.qmui_borderWidth = 1;
        }
        return _logoutButton;
}

@end
