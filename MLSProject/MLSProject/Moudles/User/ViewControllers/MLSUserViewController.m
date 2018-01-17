//
//  MLSUserViewController.m
//  MinLison
//
//  Created by MinLison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserViewController.h"
#import "MLSUserCenterPlistModel.h"
#import "MainServiceProtocol.h"
#import "MLSFormLoginViewController.h"
#import "MLSUpdateUserInfoViewController.h"
#import "MLSFeedBackViewController.h"
@interface MLSUserViewController ()
@end

@implementation MLSUserViewController
- (void)didInitializedWithStyle:(UITableViewStyle)style
{
        [super didInitializedWithStyle:style];
        self.fd_prefersNavigationBarHidden = YES;
}
- (void)viewDidLoad
{
        [super viewDidLoad];
        [self loadData];
}
- (void)initSubviews
{
        [super initSubviews];
        @weakify(self);
        [self.controllerView setUserViewActionBlock:^(WGUserViewActionType type) {
                @strongify(self);
                switch (type) {
                        case WGUserViewActionTypeHeadClick:
                        {
                                [self _UserHeadClick];
                        }
                                break;
                        case WGUserViewActionTypeFeedBackClick:
                        {
                                [self _FeedBackClick];
                        }
                                break;
                                
                        default:
                                break;
                }
        }];
}
- (void)_FeedBackClick
{
        id <MainServiceProtocol> mainService = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
        [mainService closeMenu:YES andPushViewController:[[MLSFeedBackViewController alloc] init]];
}
- (void)_UserHeadClick
{
        id <MainServiceProtocol> mainService = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
        if (MLSUserManager.isLogin)
        {
                // 修改个人资料
                [mainService closeMenu:YES andPushViewController:[[MLSUpdateUserInfoViewController alloc] init]];
        }
        else
        {
                [mainService closeMenu:YES andPushViewController:[[MLSFormLoginViewController alloc] init]];
        }
}
- (void)reloadData
{
        self.tableViewModel = nil;
        self.tableViewActions = nil;
        self.controllerView.tableViewModel = nil;
        self.controllerView.tableViewActions = nil;
        [self loadData];
}
- (void)loadData
{
        [self configNimbus];
//        NSArray <MLSUserCenterPlistModel *>*models = [MLSUserCenterPlistModel defaultUserCenterModels];
//        [models enumerateObjectsUsingBlock:^(MLSUserCenterPlistModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [self.tableViewModel addSectionWithTitle:nil];
//                [self.tableViewModel addObjectsFromArray:obj.content toSection:idx];
//        }];
        [self.tableView reloadData];
}
- (void)configNimbus
{
        [super configNimbus];
        [self.tableViewActions attachToClass:[MLSUserCenterCellModel class] tapBlock:^BOOL(MLSUserCenterCellModel *object, MLSUserViewController *target, NSIndexPath *indexPath) {
                id <MainServiceProtocol> mainService = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
                if (MLSUserManager.isLogin)
                {
                        [mainService closeMenu:YES andPushViewController:[AppUnit getInstanceFromClassName:object.nextClassName]];
                }
                else
                {
                        [mainService closeMenu:YES andPushViewController:[[MLSFormLoginViewController alloc] init]];
                }
                
                return YES;
        }];
}
/// 侧滑边框大小
- (CGSize)preferredContentSize
{
        return CGSizeMake(__WGWidth(200.0), __MAIN_SCREEN_HEIGHT__);
}

@end
