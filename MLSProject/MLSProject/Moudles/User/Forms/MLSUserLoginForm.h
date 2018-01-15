//
//  MLSUserLoginForm.h
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
@interface MLSUserLoginForm : BaseModel <FXForm>

/**
 手机
 */
@property(nonatomic, copy) NSString *mobile;

/**
 短信
 */
@property(nonatomic, copy) NSString *sms_code;

/**
 密码
 */
@property(nonatomic, copy) NSString *password;
/**
 地区
 */
@property(nonatomic, copy) NSString *country_code;

@end
