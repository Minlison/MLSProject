//
//  NSError+AppError.h
//  MLSProject
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
        APP_ERROR_CODE_SUCCESS = 1,
        /**
         *  失败
         */
        APP_ERROR_CODE_ERR = 2,
        /**
         *  token 已过期
         */
        APP_ERROR_CODE_TOKEN_OUTTIME = 3,
        /**
         *  token 错误
         */
        APP_ERROR_CODE_TOKEN_FAULT = 4,
        /**
         *  手机号已存在
         */
        APP_ERROR_CODE_PHONE_EXIST = 5,
        /**
         *  手机号或密码错误
         */
        APP_ERROR_CODE_PHONE_PWD_FAULT = 6,
        /**
         *  图片验证码错误
         */
        APP_ERROR_CODE_PIC_AUTH_CODE_ERR = 7,
        /**
         *  原始密码错误
         */
        APP_ERROR_CODE_ORIGINAL_PWD_ERR= 8,
        /**
         *  原始密码错误次数过多
         */
        APP_ERROR_CODE_ORIGINAL_PWD_ERR_TIMES_MUCH = 9,
        /**
         *  新密码格式错误（6－20位）
         */
        APP_ERROR_CODE_NEW_PWD_FMT_ERR = 10,
        /**
         *  密码格式不正确（6－20位）
         */
        APP_ERROR_CODE_PWD_FMT_ERR = 11,
        /**
         *  短信发送次数过多（1天内同一手机号最多10次，同一imei也最多10次）
         */
        APP_ERROR_CODE_MSG_TIMES_MUCH = 12,
        /**
         *  短信验证码不正确
         */
        APP_ERROR_CODE_MSG_AUTH_CODE_ERR = 13,
        /**
         *  短信验证码超时
         */
        APP_ERROR_CODE_MSG_AUTH_CODE_TIMEOUT = 14,
        /**
         *  同一IP在限制时间内注册过多
         */
        APP_ERROR_CODE_IP_COUNT_MUCH = 15,
        /**
         *  用户注册后自动登陆时会员不存在
         */
        APP_ERROR_CODE_AUTO_LOGIN_USER_NOT_EXIT = 16,
        /**
         *  用户注册后自动登陆时密码不正确
         */
        APP_ERROR_CODE_AUTO_LOGIN_PWD_ERR = 17,
        /**
         *  已经点赞
         */
        APP_ERROR_CODE_ALLREADY_PRAISED = 18,
        /**
         *  用户已存在
         */
        APP_ERROR_CODE_USER_ALLREADY_EXIT = 19,
        /**
         *  用户不存在
         */
        APP_ERROR_CODE_USER_NOT_EXIT = 20,
        /**
         *  手机号格式错误
         */
        APP_ERROR_CODE_PHONE_FMT_ERR = 21,
        /**
         *  手机号不存在
         */
        APP_ERROR_CODE_PHONE_NOT_EXIT = 22,
        /**
         *  IP检测错误
         */
        APP_ERROR_CODE_IP_ERR = 23,
        /**
         *  history_ids有错误（删除观看历史）
         */
        APP_ERROR_CODE_HISTORY_ID_ERR = 24,
        /**
         *  已经收藏
         */
        APP_ERROR_CODE_ALLREADY_ENSHRINE = 25,
        /**
         *  短信验证码发送失败
         */
        APP_ERROR_CODE_MSG_AUTH_CODE_SEND_ERR = 26,
        /**
         *  禁止发表评论
         */
        APP_ERROR_CODE_FORBID_SEND_COMMENT = 27,
        /**
         *  IP 不匹配
         */
        APP_ERROR_CODE_IP_NOT_MATCH = 28,
        /**
         *  useragent 不匹配
         */
        APP_ERROR_CODE_UA_NOT_MATCH = 29,
        /**
         *  session 不存在
         */
        APP_ERROR_CODE_SESSION_NOT_EXIT = 30,
        /**
         *  内容不存在或无访问权限
         */
        APP_ERROR_CODE_CONTENT_NOT_EXIT_AUTH_FORBID = 31,
        /**
         *  搜索字符串为空或字符过多（字符数量范围：1 ~ 7个）
         */
        APP_ERROR_CODE_SEARCH_ERR = 32,
        /**
         *  点赞成功
         */
        APP_ERROR_CODE_PRISED_SUC = 33,
        /**
         *  用户头像大小（容量）过大或过小
         */
        APP_ERROR_CODE_HEAD_IMG_ERR =34,
        /**
         *  用户头像后缀不正确
         */
        APP_ERROR_CODE_HEAD_IMG_SUFFIX_ERR = 35,
        /**
         *  无权限访问此内容分类
         */
        APP_ERROR_CODE_FORBID_CONTENT = 36,
        /**
         *  此用户被禁止分享内容
         */
        APP_ERROR_CODE_FORBID_SHARE = 37,
        /**
         *  图片数量过多
         */
        APP_ERROR_CODE_IMG_MUCH = 38,
        /**
         *  图片太大
         */
        APP_ERROR_CODE_IMG_LARGE = 39,
        /**
         *  用户呢称包含屏蔽词
         */
        APP_ERROR_CODE_NICK_NAME_NOT_LEGAL = 40,
        /**
         *  重复内容，指短时间内重复提交的内容（如评论等
         */
        APP_ERROR_CODE_CONTENT_REPEAT = 41,
        /**
         *  还没收到ping++支付回调信息
         */
        APP_ERROR_CODE_NO_PINGXX_RES = 42,
        /**
         *  还没收到iOS支付校验信息
         */
        APP_ERROR_CODE_NO_IOS_INPURCHASE = 43,
        /**
         *  request_id 无效
         */
        APP_ERROR_CODE_REQUEST_ID_INVALID = 44,
        /**
         *  关闭注册
         */
        APP_ERROR_CODE_CLOSE_REGISTER = 45,
        /**
         *  关闭评论
         */
        APP_ERROR_CODE_CLOSE_COMMENT = 46,
        /**
         *  关闭修改用户信息功能（头像、密码、呢称）
         */
        APP_ERROR_CODE_CLOSE_CHANGE_USER_INFO = 47,
        /**
         *  请先升级再注册/登录
         */
        APP_ERROR_CODE_FORCE_UPDATE = 48,
        /**
         *  封禁用户
         */
        APP_ERROR_CODE_EVENLOP_USER = 49,
        /**
         *  不允许发表雷同的内容
         */
        APP_ERROR_CODE_NO_SAME_CONTENT = 50,
        /**
         * 禁止发表动态(图片涉嫌违规)
         */
        APP_ERROR_CODE_BREAK_RULE_PICTURE = 51,
        /**
         * 禁止发表动态(有敏感词封禁)
         */
        APP_ERROR_CODE_SENSITIVE_WORDS = 52,
        /**
         * 禁止发表动态(发表太过频繁)
         */
        APP_ERROR_CODE_RELEASE_TOO_FAST = 53,
        /**
         * 禁止发表动态(用户已经被封禁)
         */
        APP_ERROR_CODE_USER_RELEASE_DY_FORBID = 54,
        /**
         * 第三方登录失败
         */
        APP_ERROR_CODE_THIRD_LOGIN_FAIL = 55,
        /**
         * 第三方帐号登录后绑定手机号失败
         */
        APP_ERROR_CODE_THIRD_BINDDING_PHONE_FAIL = 56,
        /**
         * 评论发表成功,评论审核中
         */
        APP_ERROR_CODE_COMMENT_AUDITING = 57,
        
        /**
         * 不能封禁此用户（管理用户）
         */
        APP_ERROR_CODE_NOT_FORBIDDEN_USER = 58,
        
        /**
         * 此帐号已绑定（第三方登录）
         */
        APP_ERROR_CODE_BINDING_EXIT = 59,
        
        /**
         * 此帐号不是第三方帐号（第三方登录）
         */
        APP_ERROR_CODE_BINDING_NOT_EXIT = 60,
        
        /**
         * 手机号已存在（第三方登录）
         */
        APP_ERROR_CODE_BINDG_USER = 61,
        
        /**
         * token 未过期
         */
        APP_ERROR_CODE_REFRESH_TOKEN_NOT_PASSDATE = 62,
        
        
        /**
         refreshToken 过期
         */
        APP_ERROR_CODE_REFRESH_TOKEN_PASSDATE = 63,
        
        /**
         *  非法参数
         */
        APP_ERROR_CODE_ILLEGAL_PARA = 200,
        /**
         *  签名不正确
         */
        APP_ERROR_CODE_SIGN_ERROR = 201,
        /**
         *  系统版本错误
         */
        APP_ERROR_CODE_SERVER_VERSION_ERROR = 202,
        /**
         *  系统错误
         */
        APP_ERROR_CODE_SYSTEM_ERROR = 203,
        /**
         *  数据错误
         */
        APP_ERROR_CODE_DATE_ERROR = 206,
        /**
         *  暂无版本更新
         */
        APP_ERROR_CODE_NO_NEW_PACK = 207,
        /**
         *  保存 sales失败
         */
        APP_ERROR_CODE_SAVE_CHARGE_ERROR = 212,
        /**
         *  价格不一致
         */
        APP_ERROR_CODE_PRICE_ERROR = 213,
        /**
         *  支付失败
         */
        APP_ERROR_CODE_PAY_FAILUTE = 214,
        /**
         *  暂停支付(系统维护)
         */
        APP_ERROR_CODE_PAUSE_PAY = 215,
        
        /**
         * 同一手机号30秒内重复提交相同的内容
         */
        APP_ERROR_CODE_PHONE_MSG_REPEAT_30S = 308,
        
        /**
         * 同一手机号5分钟内重复提交相同的内容超过3次
         */
        APP_ERROR_CODE_PHONE_MSG_REPEAT_5_MINUTES = 309,
        
        /**
         * 此手机号进了运营商黑名单
         */
        APP_ERROR_CODE_PHONE_BLACK_LIST = 310,
        
        /**
         * 24小时内同一手机号发送次数超过限制
         */
        APP_ERROR_CODE_PHONE_MSG_24HOUR_MAX_COUNT = 317,
        
        /**
         * 不支持的国家地区
         */
        APP_ERROR_CODE_PHONE_NOT_SUPPORT = 320,
        
        /**
         *  1小时内同一手机号发送次数超过限制
         */
        APP_ERROR_CODE_PHONE_MSG_MAX_1HOUR = 322,
        
        /**
         * 发送短信频率过高
         */
        APP_ERROR_CODE_PHONE_MSG_REPEAT_HIGHT = 329,
        
        /**
         * 服务器IP没有短信发送权限（注：不用提示用户，只用于内部判断问题）
         */
        APP_ERROR_CODE_PHONE_SERVER_NO_LIMITS = 333,
        
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
@end
