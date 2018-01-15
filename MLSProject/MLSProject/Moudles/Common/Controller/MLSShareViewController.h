//
//  MLSShareViewController.h
//  ChengziZdd
//
//  Created by chengzi on 2017/10/30.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import "BaseViewController.h"
#import "STPopup.h"
typedef void(^DismissCallBackBlock)(BOOL isLogIn);
@interface MLSShareViewController : BaseViewController
@property(nonatomic, copy) DismissCallBackBlock dismissBlock;

- (STPopupController *)getPopUpController;
@end
