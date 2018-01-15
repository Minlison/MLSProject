//
//  NSError+AppError.h
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, APP_ERROR_CODE)
{
        /**
         * 参数错误
         */
        APP_ERROR_CODE_PARAMES_ERROR = -1,
        /**
         * 网络返回数据为空
         */
        APP_ERROR_CODE_REPONSE_ERROR = -2,
        /**
         *  解密失败
         */
        APP_ERROR_CODE_DETRY_ERROR = -3,
        /**
         *  网络取消
         */
        APP_ERROR_CODE_CANCELED = NSURLErrorCancelled,
        
        
#pragma mark - 服务器返回的错误信息
        /**
         *  成功
         */
        APP_ERROR_CODE_SUCCESS = 0,
        /**
         *  失败
         */
        APP_ERROR_CODE_ERR = 1,
        
        /**
         *  手机号已经注册
         */
        APP_ERROR_CODE_ERR_PHONE_ALLREADY_REGISTER = 2,
        /**
         *  token 不存在
         */
        APP_ERROR_CODE_TOKEN_NOT_EXIT = 11,
        /**
         *  token 已过期
         */
        APP_ERROR_CODE_TOKEN_OUTTIME = 13,
        
        /**
         *  内容不存在或无访问权限
         */
        APP_ERROR_CODE_CONTENT_NOT_EXIT_AUTH_FORBID = 31,
        
        /**
         refresh_token 过期
         */
        APP_ERROR_CODE_REFRESH_TOKEN_PASSDATE = 63,
        
        /**
         *  签名不正确
         */
        APP_ERROR_CODE_SIGN_ERROR = 201,
        
        /**
         *  最大错误码
         */
        APP_ERROR_CODE_MAX_CODE,
};

@interface NSError (AppError)

/**
 应用内错误

 @param code 错误码
 @return 错误
 */
+ (NSError *)appErrorWithCode:(NSInteger)code msg:(NSString *)msg remark:(NSString *)remark;

/**
 是否是应用内错误

 @return YES/NO
 */
- (BOOL)isAppError;
@end
