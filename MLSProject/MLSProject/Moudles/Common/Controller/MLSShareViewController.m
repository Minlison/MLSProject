//
//  MLSShareViewController.m
//  ChengziZdd
//
//  Created by chengzi on 2017/10/30.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import "MLSShareViewController.h"
#import "CZShare.h"
@interface MLSShareViewController ()

@property(nonatomic, strong) UIButton *closeBtn;
@property (strong, nonatomic) UIView *shareView;
@property(nonatomic, assign) BOOL firstAppear;
@end

@implementation MLSShareViewController
- (instancetype)init
{
        self = [super init];
        if (self) {
                CGFloat w = __MAIN_SCREEN_WIDTH__;
                CGFloat h = __WGWidth(150.0f);
                self.contentSizeInPopup = CGSizeMake(w,h);
                self.landscapeContentSizeInPopup = CGSizeMake(w,h);
                self.firstAppear = YES;
        }
        return self;
}
- (void)viewDidLoad
{
        [super viewDidLoad];
        self.view.backgroundColor = [UIColor brownColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
        [self _LayoutViews];
        
}
- (void)applicationDidBecomeActive
{
        @weakify(self);
        [self.popupController dismissWithCompletion:^{
                @strongify(self);
                if (self.dismissBlock)
                {
                }
        }];
}
- (void)viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
        if (!self.firstAppear)
        {
                @weakify(self);
                [self.popupController dismissWithCompletion:^{
                        @strongify(self);
                        if (self.dismissBlock)
                        {
                        }
                }];
        }
        self.firstAppear = NO;
}

- (STPopupController *)getPopUpController
{
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self];
        popupController.navigationBarHidden = YES;
        popupController.style = STPopupStyleBottomSheet;
        @weakify(self);
        popupController.DissmissCallBack = ^{
                @strongify(self);
                if (self.dismissBlock)
                {
                }
        };
        return popupController;
}
- (void)_LayoutViews
{
        [self.view addSubview:self.closeBtn];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-10);
                make.centerX.equalTo(self.view.mas_centerX);
                make.height.width.mas_equalTo(30.0f);
        }];
        
        ShareType type = ShareTypeDefault;
        
        self.shareView = [CZShare shareView:@"" text:@"" url:@"" image:@"" shareType:type completion:^(BOOL success, NSString *errorReason,ShareType type) {
                
                if (errorReason != nil)
                {
                        [WGTipTool showWithText:errorReason inView:self.view hideAfterDelay:1.5];
                       
                }
                else
                {
                        [WGTipTool showWithText:@"分享成功" inView:self.view hideAfterDelay:1.5];
                }
        }];
        
        [self.view addSubview:self.shareView];
        
        [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.view.mas_top);
                
                make.leading.trailing.equalTo(self.view);
                
                make.height.offset(__WGWidth(100.0f));
        }];
}

- (UIButton *)closeBtn
{
        if (_closeBtn == nil) {
                _closeBtn = [[UIButton alloc] init];
                [_closeBtn setImage:[UIImage imageNamed:@"store_close"] forState:UIControlStateNormal];
                [_closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        return _closeBtn;
}

-(void)closeClick:(UIButton *)closeBtn
{
        [self.popupController dismiss];
}

@end
