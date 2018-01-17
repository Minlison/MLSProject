//
//  MLSSetPwdCompleteCell.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSSetPwdCompleteCell.h"

@implementation MLSSetPwdCompleteCell
- (void)setUp
{
        [super setUp];
        @weakify(self);
        [self adjustButtonEnable];
        [self.KVOController observe:MLSUserManager keyPath:@keypath(MLSUserManager,password) options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                @strongify(self);
                [self adjustButtonEnable];
        }];
        [self.KVOController observe:MLSUserManager keyPath:@keypath(MLSUserManager,repeat_password) options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                @strongify(self);
                [self adjustButtonEnable];
        }];
}
- (void)adjustButtonEnable
{
        BOOL res = (!NULLString(MLSUserManager.password) && !NULLString(MLSUserManager.repeat_password) &&  [MLSUserManager.password isEqualToString:MLSUserManager.repeat_password]);
        if (self.button.isEnabled != res) {
                self.button.enabled = res;
        }
}
@end
