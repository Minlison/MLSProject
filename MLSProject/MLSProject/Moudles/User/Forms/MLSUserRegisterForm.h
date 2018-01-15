//
//  MLSUserRegisterForm.h
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseModel.h"

@interface MLSUserRegisterForm : BaseModel<FXForm>
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *sms_code;
@property(nonatomic, assign) BOOL agreement;
@end
