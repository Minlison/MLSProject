//
//  MLSModifyInfoView.h
//  MLSProject
//
//  Created by MinLison on 2017/12/11.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseControllerView.h"
typedef void (^LNModifyValidatorBlock)(BOOL validator);
@interface MLSModifyInfoView : BaseControllerView
@property(nonatomic, strong) XLFormRowDescriptor *rowDescriptor;
@property(nonatomic, copy) LNModifyValidatorBlock validatorAction;
@property(nonatomic, assign, readonly) BOOL isValidator;
@end
