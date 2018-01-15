//
//  MLSModifyInfoViewController.h
//  MLSProject
//
//  Created by MinLison on 2017/12/11.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseViewController.h"
#import "MLSModifyInfoView.h"
@interface MLSModifyInfoViewController : BaseViewController <MLSModifyInfoView *>
@property(nonatomic, strong) XLFormRowDescriptor *rowDescriptor;
@end
