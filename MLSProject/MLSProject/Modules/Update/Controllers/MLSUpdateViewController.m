//
//  MLSUpdateViewController.m
//  MLSProject
//
//  Created by MinLison on 2017/10/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUpdateViewController.h"
#import "MLSUpdateViewModel.h"
#import <STPopup/STPopup.h>
#import "MLSUpdateRequest.h"

@SERVICE_REGISTER(MLSUpdateProtocol, MLSUpdateViewController)

static MLSUpdateViewController *updateVC = nil;

@interface MLSUpdateViewController ()
@property(nonatomic, strong) MLSUpdateRequest *request;
@property(nonatomic, weak) UIViewController *callVC;
@property(nonatomic, strong) MLSUpdateViewModel *viewModel;
@property(nonatomic, copy) MLSUpdateActionBlock completionBlock;
@end

@implementation MLSUpdateViewController
- (instancetype)init
{
        self = [super init];
        if (self)
        {
                self.contentSizeInPopup = __MAIN_SCREEN_BOUNDS__.size;
                self.landscapeContentSizeInPopup = __MAIN_SCREEN_BOUNDS__.size;
                self.viewModel = [[MLSUpdateViewModel alloc] init];
                updateVC = self;
        }
        return self;
}
- (UIViewController *)getController
{
        if (updateVC) {
                return updateVC;
        }
        return [[MLSUpdateViewController alloc] init];
}
- (void)viewDidLoad
{
        [super viewDidLoad];
        self.controllerView.updateModel = self.viewModel.model;
        @weakify(self);
        [self.controllerView setActionBlock:^(MLSUpdateActionType type) {
                @strongify(self);
                switch (type)
                {
                        case MLSUpdateActionTypeLater:
                        {
                                [self.viewModel latter];
                        }
                                break;
                        case MLSUpdateActionTypeNow:
                        {
                                [self.viewModel updateNow];
                        }
                                break;
                                
                        default:
                                break;
                }
                [self dismissPopViewController];
                if (self.completionBlock)
                {
                        self.completionBlock(type);
                }
        }];
}


- (void)showInViewController:(UIViewController *)vc completion:(MLSUpdateActionBlock)completion
{
        self.callVC = vc;
        self.completionBlock = completion;
        [self _ShowPopUpView];
//        [self.request startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof MLSUpdateModel * _Nonnull data) {
//                self.viewModel.model = data;
//                [self _ShowPopUpView];
//        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
//                NSLogError(@"%@",error);
//        }];
}
- (void)_ShowPopUpView
{
        if (self.viewModel.canShow)
        {
                [self showPopViewController];
        }
        else
        {
                if (self.completionBlock)
                {
                        self.completionBlock(MLSUpdateActionTypeLater);
                }
                [self dismissPopViewController];
        }
}
- (void)showPopViewController
{
        if (self.callVC)
        {
                [[self getPopupController] presentInViewController:self.callVC];
        }
}
- (void)dismissPopViewController
{
        [self.popupController dismiss];
        updateVC = nil;
}

- (MLSUpdateRequest *)request
{
        if (!_request) {
                _request = [MLSUpdateRequest requestWithParams:nil];
        }
        return _request;
}

- (STPopupController *)getPopupController
{
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self];
        popupController.navigationBarHidden = YES;
        popupController.containerView.layer.cornerRadius = 0;
        popupController.containerView.backgroundColor = [UIColor clearColor];
        popupController.style = STPopupStyleFormSheet;
        popupController.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        return popupController;
}
@end
