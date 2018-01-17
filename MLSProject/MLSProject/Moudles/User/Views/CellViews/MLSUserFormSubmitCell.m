//
//  MLSUserFormSubmitCell.m
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserFormSubmitCell.h"

@interface MLSUserFormSubmitCell ()
@end

@implementation MLSUserFormSubmitCell

+ (CGFloat)heightForField:(FXFormField *)field width:(CGFloat)width
{
        return 100;
}
- (void)didSelectWithTableView:(UITableView *)tableView controller:(UIViewController *)controller
{
        // do nothing
}
- (void)setUp
{
        [super setUp];
        @weakify(self);
        [self.KVOController observe:MLSUserManager keyPath:@keypath(MLSUserManager,canLogin) options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                @strongify(self);
                if (self.button.isEnabled != MLSUserManager.canLogin) {
                        self.button.enabled = MLSUserManager.canLogin;
                }
                
        }];
}

@end
