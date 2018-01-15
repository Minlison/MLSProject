//
//  MLSUserFindPwdNextCell.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUserFindPwdNextCell.h"
#import "MLSPhoneCondition.h"
#import "MLSSMSCondition.h"
@implementation MLSUserFindPwdNextCell

- (void)setUp
{
        [super setUp];
        [self adjustButtonEnable];
        
        @weakify(self);
        [self.KVOController observe:LNUserManager keyPath:@keypath(LNUserManager,sms_code) options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                @strongify(self);
                [self adjustButtonEnable];
        }];
        
        [self.KVOController observe:LNUserManager keyPath:@keypath(LNUserManager,mobile) options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                @strongify(self);
                [self adjustButtonEnable];
        }];
}

- (void)adjustButtonEnable
{
        BOOL res = [[MLSPhoneCondition condition] check:LNUserManager.mobile] && [[MLSSMSCondition condition] check:LNUserManager.sms_code];
        if (self.button.isEnabled != res)
        {
                self.button.enabled = res;
        }
}

@end
