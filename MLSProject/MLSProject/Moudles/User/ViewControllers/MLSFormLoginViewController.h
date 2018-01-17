//
//  MLSFormLoginViewController.h
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MLSFormLoginView.h"
@interface MLSFormLoginViewController : BaseTableViewController <MLSFormLoginView *>
- (void)presentOrPushInViewController:(UIViewController *)viewController;
@end
