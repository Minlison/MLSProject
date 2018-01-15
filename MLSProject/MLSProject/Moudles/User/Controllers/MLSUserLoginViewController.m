//
//  MLSUserLoginViewController.m
//  ChengziZdd
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import "MLSUserLoginViewController.h"
@interface MLSUserLoginViewController ()
@end

@implementation MLSUserLoginViewController

- (void)initSubviews
{
        [super initSubviews];
        self.title = [NSString app_Login];
        [self.controllerView setLoginAction:^(WGThirdLoginType type) {
                
                [WGUserManager loginType:type param:nil success:^(MLSUserModel * _Nonnull user) {
                        
                } failed:^(NSError * _Nonnull error) {
                        
                }];
        }];
        
        [self.controllerView setGetSMSAction:^(void) {
                [WGUserManager getSMSWithParam:nil success:^(NSString * _Nonnull sms) {
                        
                } failed:^(NSError * _Nonnull error) {
                        
                }];
        }];
}

@end
