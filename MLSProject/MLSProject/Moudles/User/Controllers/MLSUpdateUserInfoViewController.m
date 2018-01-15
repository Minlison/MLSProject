//
//  MLSUpdateUserInfoViewController.m
//  MinLison
//
//  Created by MinLison on 2017/11/5.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUpdateUserInfoViewController.h"
#import "MLSUploadImageRequest.h"
#import "MLSImagePickerViewController.h"
#import "MLSUpdateUserInfoForm.h"
@interface MLSUpdateUserInfoViewController ()
@property(nonatomic, strong) MLSUploadImageRequest *uploadImgRequest;
@end

@implementation MLSUpdateUserInfoViewController

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.title = @"编辑个人资料";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorHex(0xf5f5f5);
        self.form = [[MLSUpdateUserInfoForm alloc] init];
}
- (void)viewWillAppear:(BOOL)animated
{
        [super viewWillAppear:animated];
        self.form = [[MLSUpdateUserInfoForm alloc] init];
        [self.tableView reloadData];
}
- (void)presentOrPushInViewController:(UIViewController *)viewController dismiss:(void (^)(void))dismiss
{
        self.dismissBlock = dismiss;
        if (viewController.navigationController) {
                [viewController.navigationController pushViewController:self animated:YES];
        } else {
                BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:self];
                [viewController presentViewController:nav animated:YES completion:nil];
        }
}
- (void)backButtonDidClick:(UIButton *)button
{
        if (self.navigationController.viewControllers.lastObject == self && self.popupController) {
                [self.navigationController dismissViewControllerAnimated:YES completion:self.dismissBlock];
        } else {
                [super backButtonDidClick:button];
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        if (section == 1) {
                return __WGHeight(11);
        }
        return CGFLOAT_MIN;
}
+ (UIViewController<JLRRouteDefinitionTargetController> *)targetControllerWithParams:(NSDictionary *)parameters
{
        return [[MLSUpdateUserInfoViewController alloc] init];
}
@end
