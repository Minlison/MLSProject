//
//  MLSUserView.m
//  MinLison
//
//  Created by MinLison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserView.h"
#import "MLSUserTableHeaderView.h"
#import "MLSUserTableFooterView.h"
#import "MLSUserCenterCell.h"

@interface MLSUserView ()
@property(nonatomic, strong) MLSUserTableHeaderView *headView;
@property(nonatomic, strong) MLSUserTableFooterView *footerView;
@property(nonatomic, copy) WGUserViewActionBlock actionBlock;
@end

@implementation MLSUserView
- (void)setUserViewActionBlock:(WGUserViewActionBlock)clickBlock
{
        self.actionBlock = clickBlock;
}
- (void)setupView
{
        [super setupView];
        [self setupHeaderFooterView];
        @weakify(self);
        [self.tableView aspect_hookSelector:@selector(reloadData) withOptions:(AspectPositionAfter) usingBlock:^{
                @strongify(self);
                [self setupHeaderFooterView];
        } error:nil];
        
        [self.footerView setFeedBackAction:^{
                @strongify(self);
                [self userHeadViewAction:(WGUserViewActionTypeFeedBackClick)];
        }];
        [self.headView setUserHeadClickBlock:^{
                @strongify(self);
                [self userHeadViewAction:(WGUserViewActionTypeHeadClick)];
        }];
}
- (void)userHeadViewAction:(WGUserViewActionType)type
{
        if (self.actionBlock) {
                self.actionBlock(type);
        }
}
- (void)setupTableView
{
        self.tableView.bounces = NO;
        [self addSubview:self.tableView];
        [self addSubview:self.footerView];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                if (@available(iOS 11.0, *))
                {
                        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
                        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
                        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
                }
                else
                {
                        make.top.left.right.equalTo(self);
                }
        }];
        [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11.0, *))
                {
                        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
                        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
                        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
                }
                else
                {
                        make.bottom.left.right.equalTo(self);
                }
                make.height.mas_equalTo(__WGWidth(100));
                make.top.equalTo(self.tableView.mas_bottom);
        }];
}
- (void)setupHeaderFooterView
{
        self.tableView.tableHeaderView = self.headView;
        [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.tableView);
                make.width.equalTo(self.tableView);
                make.height.mas_equalTo(__WGWidth(260));
        }];
        [self.tableView layoutIfNeeded];
        self.tableView.tableHeaderView = self.headView;
        self.tableView.tableFooterView = nil;
}

- (MLSUserTableHeaderView *)headView
{
        if (_headView == nil) {
                _headView = [[MLSUserTableHeaderView alloc] initWithFrame:CGRectZero];
        }
        return _headView;
}
- (MLSUserTableFooterView *)footerView
{
        if (_footerView == nil) {
                _footerView = [[MLSUserTableFooterView alloc] initWithFrame:CGRectZero];
        }
        return _footerView;
}
@end
