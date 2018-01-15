//
//  MLSFormLoginView.m
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSFormLoginView.h"
#import "FXForms.h"
#import "MLSUserLoginForm.h"
#import "MLSUserFormLoginCell.h"
#import "MLSUserThirdLoginView.h"
@interface MLSFormLoginView ()<FXFormControllerDelegate>
@property (nonatomic, strong) FXFormController *formController;
@property(nonatomic, strong) MLSUserThirdLoginView *thirdLoginView;
@end

@implementation MLSFormLoginView
- (void)setupView
{
        [super setupView];
}
- (void)configForm
{
        self.formController = [[FXFormController alloc] init];
        self.formController.form = [[MLSUserLoginForm alloc] init];
        self.formController.delegate = self;
        self.formController.tableView = self.tableView;
}
- (void)setupTableView
{
        [self configForm];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.bounces = NO;
//        [self addSubview:self.thirdLoginView];
        
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
        
//        [self.thirdLoginView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.tableView.mas_bottom);
//                make.bottom.equalTo(self).offset(-__WGWidth(20));
//                make.left.right.equalTo(self);
//        }];
        
        
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
        if ([cell respondsToSelector:@selector(setShowBootomLine:)]) {
                [cell performSelectorWithArgs:@selector(setShowBootomLine:),YES];
        }
}

//- (MLSUserThirdLoginView *)thirdLoginView
//{
//        if (_thirdLoginView == nil) {
//                _thirdLoginView = [[MLSUserThirdLoginView alloc] initWithFrame:CGRectZero];
//                @weakify(self);
//                [_thirdLoginView setThirdLoginAction:^(LNLoginType type) {
//                        @strongify(self);
//                        if (self.actionBlock) {
//                                self.actionBlock(LNFormLoginViewClickTypeThirdLoginClick,type,nil,nil);
//                        }
//                }];
//        }
//        return _thirdLoginView;
//}
/// FormAction
- (void)phoneLogin
{
        if (self.actionBlock)
        {
                MLSUserLoginForm *form = (MLSUserLoginForm *)self.formController.form;
                self.actionBlock(LNFormLoginViewClickTypeLoginClick,LNLoginTypePhone,[form modelToJSONObject],nil);
        }
}
- (void)webCatLogin
{
        if (self.actionBlock)
        {
                self.actionBlock(LNFormLoginViewClickTypeThirdLoginClick,LNLoginTypeWebchat,nil,nil);
        }
}
- (void)getSMSCode
{
        if (self.actionBlock)
        {
                MLSUserLoginForm *form = (MLSUserLoginForm *)self.formController.form;
                self.actionBlock(LNFormLoginViewClickTypeGetSmsCode,LNLoginTypeUnKnown,[form modelToJSONObject],nil);
        }
}
- (void)findPwd
{
        if (self.actionBlock)
        {
                MLSUserLoginForm *form = (MLSUserLoginForm *)self.formController.form;
                self.actionBlock(LNFormLoginViewClickTypeFindPwd,LNLoginTypeUnKnown,[form modelToJSONObject],nil);
        }
}
- (void)getCountryCode
{
        if (self.actionBlock)
        {
                MLSUserLoginForm *form = (MLSUserLoginForm *)self.formController.form;
                self.actionBlock(LNFormLoginViewClickTypeGetCountryCode,LNLoginTypeUnKnown,[form modelToJSONObject],^(NSString *str) {
                        LNUserManager.country_code = str;
                });
        }
}

@end
