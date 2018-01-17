//
//  MLSUserSetPwdForm.h
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseModel.h"
typedef NS_ENUM(NSInteger,MLSSetPwdType)
{
        MLSSetPwdTypeRegister,
        MLSSetPwdTypeFindPwd,
};
@interface MLSUserSetPwdForm : BaseModel<FXForm>
@property(nonatomic, copy) NSString *password;
@property(nonatomic, copy) NSString *repeatPassword;
@property(nonatomic, assign) MLSSetPwdType type;
- (instancetype)initWithType:(MLSSetPwdType)type;
@end
