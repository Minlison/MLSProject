//
//  MLSUserNextCell.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUserNextCell.h"

@implementation MLSUserNextCell

- (void)setUp
{
        [super setUp];
        [self adjustButtonEnable];
        @weakify(self);
        [self.KVOController observe:LNUserManager keyPath:@keypath(LNUserManager,canRegister) options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                @strongify(self);
                [self adjustButtonEnable];
        }];
}
- (void)adjustButtonEnable
{
        if (self.button.isEnabled != LNUserManager.canRegister) {
                self.button.enabled = LNUserManager.canRegister;
        }
        
}
@end
