//
//  MLSUser.h
//  MLSProject
//
//  Created by MinLison on 2017/10/09.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLSUserModel.h"
NS_ASSUME_NONNULL_BEGIN

#define MLSUserManager [MLSUser shareUser]

@interface MLSUser : NSObject

/**
 用户模型信息
 如果设置为空, 则清楚本地用户模型
 */
@property(nonatomic, strong, null_resettable) MLSUserModel *userModel;

/**
 用户 id
 获取的不会为 nil, 
 */
@property(nonatomic, copy, readonly) NSString *user_id;
/**
 用户管理工具
 会加载本地存储的用户信息

 @return 单例
 */
+ (instancetype)shareUser;
@end

NS_ASSUME_NONNULL_END
