//
//  RequestKeyString.h
//  MLSProject
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 定义字符串时, 按照 kRequestKey 前缀加参数名首字母大写的命名规则
 */

#ifndef RequestKeyString_h
#define RequestKeyString_h
/// 请求参数
//MARK: - Defaut Pramams Key
FOUNDATION_EXTERN  NSString *const kRequestKeyMethod;
FOUNDATION_EXTERN  NSString *const kRequestKeyMethodVersion;
FOUNDATION_EXTERN  NSString *const kRequestKeyNetType;
FOUNDATION_EXTERN  NSString *const kRequestKeyUUID;
FOUNDATION_EXTERN  NSString *const kRequestKeySysType;
FOUNDATION_EXTERN  NSString *const kRequestKeyAppVersionCode;
FOUNDATION_EXTERN  NSString *const kRequestKeyUserID;
FOUNDATION_EXTERN  NSString *const kRequestKeyPage;
FOUNDATION_EXTERN  NSString *const kRequestKeyPosition;
FOUNDATION_EXTERN  NSString *const kRequestKeyID;

#endif
