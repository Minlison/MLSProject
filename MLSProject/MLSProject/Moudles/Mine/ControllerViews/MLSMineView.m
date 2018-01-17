//
//  MLSMineView.m
//  MLSProject
//
//  Created by MinLison on 2017/11/30.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSMineView.h"
#import "MLSMineHeaderView.h"
@implementation MLSMineView
- (void)setupTableView
{
        BOOL showComment = [self.controller alwaysShowCommentView];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
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
                        make.top.equalTo(self);
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
                        make.top.equalTo(self);
                        make.left.right.equalTo(self);
                }
        }];
        MLSMineHeaderView *view = [[MLSMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, __WGHeight(140))];
        self.tableView.tableHeaderView = view;
        self.tableView.autoAdjustView = view.backGroundView;
        self.tableView.enableAutoAdjustHeader = YES;
        @weakify(self);
        view.actionBlock = ^(MLSMineHeaderViewClickType type) {
                @strongify(self);
                if (self.actionBlock)
                {
                        self.actionBlock((MLSMineViewClickType)type);
                }
        };
}
@end
