//
//  MLSUserRegisterModel.h
//  MinLison
//
//  Created by MinLison on 2017/11/2.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserModel.h"

@interface MLSUserRegisterModel : MLSUserModel

/**
 短信验证码
 */
@property(nonatomic, copy) NSString *sms_code;

@end
