//
//  MLSUpdateViewController.m
//  MinLison
//
//  Created by MinLison on 2017/10/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUpdateViewController.h"
#import "MLSUpdateViewModel.h"
#import "MLSUpdateRequest.h"
#import "MLSUpdateEnum.h"
#if WGEnablePgyerSDK
#import "MLSPgyerUpdateRequest.h"
#endif

@SERVICE_REGISTER(MLSUpdateProtocol, MLSUpdateViewController)

@interface MLSUpdateViewController ()
@property(nonatomic, strong) MLSUpdateRequest *request;
@property(nonatomic, strong) MLSUpdateViewModel *viewModel;
@property(nonatomic, copy) WGUpdateActionBlock completionBlock;
@property(nonatomic, strong) UIWindow *containerWindow;
@property(nonatomic, strong) UIViewController *containerViewController;
@end

@implementation MLSUpdateViewController
+ (BOOL)singleton
{
        return YES;
}
+ (instancetype)shareInstance {
        static dispatch_once_t onceToken;
        static MLSUpdateViewController *instance = nil;
        dispatch_once(&onceToken,^{
                instance = [[super alloc] init];
        });
        return instance;
}

- (instancetype)init
{
        self = [super init];
        if (self)
        {
                self.contentSizeInPopup = __MAIN_SCREEN_BOUNDS__.size;
                self.landscapeContentSizeInPopup = __MAIN_SCREEN_BOUNDS__.size;
                self.viewModel = [[MLSUpdateViewModel alloc] init];
        }
        return self;
}
- (void)viewDidLoad
{
        [super viewDidLoad];
        self.controllerView.updateModel = self.viewModel.model;
        @weakify(self);
        [self.controllerView setActionBlock:^(WGUpdateActionType type) {
                @strongify(self);
                switch (type)
                {
                        case WGUpdateActionTypeLater:
                        {
                                [self.viewModel latter];
                        }
                                break;
                        case WGUpdateActionTypeNow:
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

- (void)showInViewController:(UIViewController *)vc completion:(WGUpdateActionBlock)completion
{
        self.completionBlock = completion;
        [self checkUpdate];
}
- (void)checkUpdate
{
        if (self.request.isExecuting)
        {
                return;
        }
        [self.request startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof MLSUpdateModel * _Nonnull data) {
                self.viewModel.model = data;
                self.controllerView.updateModel = data;
                [self _ShowPopUpView];
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                NSLogError(@"%@",error);
#if WGEnablePgyerSDK
                [self updatePgyer];
#endif
        }];
}


#if WGEnablePgyerSDK
- (MLSUpdateModel *)getUpdateModelWithPgyerModel:(MLSPgyerUpdateModel *)model
{
        MLSUpdateModel *updateModel = [[MLSUpdateModel alloc] init];
        updateModel.version = model.buildVersion;
        updateModel.version_code = model.buildVersionNo;
        updateModel.update_type = WGUpdateTypeEmergency;
        updateModel.content = model.buildUpdateDescription;
        updateModel.url = model.buildDonwloadUrl;
        return updateModel;
}
- (void)updatePgyer
{
        [[MLSPgyerUpdateRequest requestWithParams:nil] startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof MLSPgyerUpdateModel * _Nonnull data) {
                MLSUpdateModel *updateModel = [self getUpdateModelWithPgyerModel:data];
                self.viewModel.model = updateModel;
                self.controllerView.updateModel = updateModel;
                [self _ShowPopUpView];
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                NSLogError(@"%@",error);
        }];
}

#endif
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
                        self.completionBlock(WGUpdateActionTypeLater);
                }
        }
}
- (void)showPopViewController
{
        if (self.popupController != nil)
        {
                return;
        }
        if (!self.containerWindow)
        {
                self.containerWindow = [[UIWindow alloc] init];
                self.containerWindow.backgroundColor = [UIColor clearColor];
                self.containerWindow.windowLevel = UIWindowLevelAlert;
        }
        if (!self.containerViewController)
        {
                self.containerViewController = [[UIViewController alloc] init];
                self.containerViewController.view.backgroundColor = [UIColor clearColor];
        }
        self.containerWindow.rootViewController = self.containerViewController;
        [self.containerWindow makeKeyAndVisible];
        
        [[self getPopupController] presentInViewController:self.containerViewController];
}
- (void)dismissPopViewController
{
        if (self.containerWindow) {
                [self beginAppearanceTransition:NO animated:YES];
                [self.containerWindow resignKeyWindow];
                self.containerWindow.rootViewController = nil;
                self.containerWindow = nil;
                self.containerViewController = nil;
        }
        [self.popupController dismiss];
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
- (nullable __kindof UIViewController *)getController
{
        return nil;
}
@end
