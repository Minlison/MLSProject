//
//  MLSUserModel.h
//  MinLison
//
//  Created by MinLison on 2017/9/22.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface MLSUserModel : BaseModel
/**
 用户 ID
 */
@property(nonatomic, copy) NSString *uid;

/**
 手机号码
 */
@property(nonatomic, copy) NSString *mobile;
/**
 昵称
 */
@property(nonatomic, copy) NSString *nickname;

/**
 头像地址
 */
@property(nonatomic, copy) NSString *img;

/**
 角色ID（请查看首页的“用户角色”），目前只用于判断是否有权限封禁评论
 */
@property(nonatomic, copy) NSString *role;

/**
 用户识别码
 */
@property(nonatomic, copy) NSString *token;

/**
 用于刷新token的密钥
 */
@property(nonatomic, copy) NSString *refresh_token;

/**
 国家或地区的编码
 */
@property(nonatomic, copy) NSString *country_code;

/**
 姓名
 */
@property(nonatomic, copy) NSString *name;

/**
 生日
 */
@property(nonatomic, copy) NSString *date;

/**
 性别
 */
@property(nonatomic, copy) NSString *gender;

/**
 地址
 */
@property(nonatomic, strong) NSString *address;

/**
 邮箱
 */
@property(nonatomic, copy) NSString *email;

/**
 身份证号
 */
@property(nonatomic, copy) NSString *id_number;
/**
 是否是新用户：
 0：不是
 1：是
 */
@property(nonatomic, assign) BOOL is_new_user;

@end
NS_ASSUME_NONNULL_END
