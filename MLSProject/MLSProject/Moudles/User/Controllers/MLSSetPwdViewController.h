//
//  MLSSetPwdViewController.h
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MLSSetPwdView.h"
#import "MLSUserSetPwdForm.h"
@interface MLSSetPwdViewController : BaseTableViewController <MLSSetPwdView *>
@property(nonatomic, assign) LNSetPwdType type;
@end
