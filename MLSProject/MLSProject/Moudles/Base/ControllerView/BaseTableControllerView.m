//
//  BaseTableControllerView.m
//  MinLison
//
//  Created by MinLison on 2017/10/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTableControllerView.h"
#import "BaseTableView.h"

@interface BaseTableControllerView ()
@property(nonatomic, strong, readwrite) __kindof BaseTableView *tableView;
@end

@implementation BaseTableControllerView
- (void)setTableView:(__kindof BaseTableView *)tableView
{
        _tableView = tableView;
}
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
                        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
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
                        make.top.equalTo(self.controller.mas_topLayoutGuideBottom);
                        make.left.right.equalTo(self);
                }
        }];
}
- (void)setupView
{
        [super setupView];
        [self addSubview:self.tableView];
        [self setupTableView];
}

- (void)setTableViewModel:(NIMutableTableViewModel *)tableViewModel
{
        _tableViewModel = tableViewModel;
        
        self.tableView.dataSource = tableViewModel;
}
- (void)setTableViewActions:(NITableViewActions *)tableViewActions
{
        _tableViewActions = tableViewActions;
        self.tableView.delegate = tableViewActions;
}
@end
