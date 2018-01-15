//
//  MLSUserSetPwdForm.h
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseModel.h"
typedef NS_ENUM(NSInteger,LNSetPwdType)
{
        LNSetPwdTypeRegister,
        LNSetPwdTypeFindPwd,
};
@interface MLSUserSetPwdForm : BaseModel<FXForm>
@property(nonatomic, copy) NSString *password;
@property(nonatomic, copy) NSString *repeatPassword;
@property(nonatomic, assign) LNSetPwdType type;
- (instancetype)initWithType:(LNSetPwdType)type;
@end
