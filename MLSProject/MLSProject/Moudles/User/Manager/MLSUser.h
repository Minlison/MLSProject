//
//  MLSUser.h
//  MinLison
//
//  Created by MinLison on 2017/9/22.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLSUserModel.h"
#import "MLSUserRegisterModel.h"
#import "MLSUserPhoneLoginRequest.h"
#import "MLSUserThirdLoginRequest.h"
#import "MLSYardModel.h"
#import "MLSUserSettingModel.h"
NS_ASSUME_NONNULL_BEGIN
@class MLSUser;
@class MLSYardModel;
typedef void (^WGUserLoginSuccessBlock)(MLSUserModel *user);
typedef void (^WGUserStringSuccessBlock)(NSString *sms);
typedef void (^WGUserFailedBlock)(NSError *error);
#define LNUserManager [MLSUser shareUser]

FOUNDATION_EXTERN NSInteger const kGetSMSCountTime;

@interface MLSUser : MLSUserModel

/**
 用户管理工具
 会加载本地存储的用户信息

 @return 单例
 */
+ (instancetype)shareUser;

/**
 经度
 */
@property(nonatomic, copy) NSString *longitude;

/**
 纬度
 */
@property(nonatomic, copy) NSString *latitude;

/**
 最近的园区
 */
@property(nonatomic, strong) MLSYardModel *currentYardModel;


/**
 登录类型
 */
@property(nonatomic, assign) LNLoginType loginType;

/**
 短信校验码
 */
@property(nonatomic, copy, nullable) NSString *sms_code;

/**
 密码
 */
@property(nonatomic, copy, nullable) NSString *password;

/**
 确认密码
 */
@property(nonatomic, copy, nullable) NSString *repeat_password;

/**
 原来的昵称，计算属性，用来做昵称修改判断
 */
@property(nonatomic, copy) NSString *old_nickname;

/**
 是否已经登录
 */
/// KVO can begin
@property(nonatomic, assign, readonly, getter=isLogin) BOOL login;

/**
 是否已经登出
 */
@property(nonatomic, assign, readonly, getter=isLogout) BOOL logout;

/**
 是否选择了允许协议
 */
@property(nonatomic, assign, getter=isCheckAgreement) BOOL checkAgreement;

/**
 是否可以注册（查看参数是否够用）
 */
@property(nonatomic, assign, readonly) BOOL canRegister;

/**
 是否可以登录（查看参数是否够用）
 */
@property(nonatomic, assign, readonly) BOOL canLogin;

/**
 用户信息是否完善
 */
@property(nonatomic, assign, getter=isUserInfoComplete) BOOL userInfoComplete;

/**
 是否需要修改用户信息
 */
@property(nonatomic, assign, readonly, getter=isNeedModifyUserInfo) BOOL needModifyUserInfo;

/**
 用户信息更改了，需要在界面上展示
 */
@property(nonatomic, assign) BOOL userInfoDidChange;

/**
 用户个性化设置
 */
@property(nonatomic, strong) MLSUserSettingModel *userSetting;

/**
 底部弹框登录
 会直接弹出
 @param viewController 在哪个界面登录,如果为空，则选择栈顶控制器
 @param completion 完成回调
 @param dismiss 界面消失后回调
 */
- (void)popLoginInViewController:(nullable UIViewController *)viewController completion:(nullable void (^)(void))completion dismiss:(nullable void (^)(void))dismiss;

/**
 弹出登录框（底部弹框）
 内部会判断用户是否已经登录，如果登录，直接回调 completion 和 dismiss，如果没有登录，会弹出登录界面

 @param viewController 在哪个界面登录,如果为空，则选择栈顶控制器
 @param completion 完成回调
 @param dismiss 界面消失后回调
 */
- (void)popLoginIfNeedInViewController:(nullable UIViewController *)viewController completion:(nullable void (^)(void))completion dismiss:(nullable void (^)(void))dismiss;


/**
 进入登录视图

 @param ifNeed 是否在需要时弹出，如果设置为 NO ，则强制进入登录视图
 @param viewController 在哪个界面登录,如果为空，则选择栈顶控制器
 @param completion 完成回调
 @param dismiss 界面消失后回调
 */
- (void)pushOrPresentLoginIfNeed:(BOOL)ifNeed inViewController:(nullable UIViewController *)viewController completion:(nullable void (^)(void))completion dismiss:(nullable void (^)(void))dismiss;

/**
 弹出补全信息界面
 内部判断信息是否完善，如果不完善就弹出
 强制弹出
 
 @param viewController 在哪个界面登录,如果为空，则选择栈顶控制器
 @param completion 不会回调
 @param dismiss 界面消失后回调
 */
- (void)pushOrPresentUserInfoInViewController:(nullable UIViewController *)viewController completion:(nullable void (^)(void))completion dismiss:(nullable void (^)(void))dismiss;
/**
 弹出补全信息界面
 内部判断信息是否完善，如果不完善就弹出
 如果没有登录，内部会弹出登录界面
 
 @param viewController 在哪个界面登录,如果为空，则选择栈顶控制器
 @param completion 不会回调
 @param dismiss 界面消失后回调
 */
- (void)pushOrPresentUserInfoIfNeedInViewController:(nullable UIViewController *)viewController completion:(nullable void (^)(void))completion dismiss:(nullable void (^)(void))dismiss;
/**
 获取短信验证码剩余事件

 @return 剩余事件 单位 秒
 */
- (int)getSMSResidueCountTime;

/**
 上次倒计时是否已经完成
 */
- (BOOL)isLastSMSCountTimeCompletion;

/**
 手机登录/注册/三方登录 根据 loginType 判断
 
 @param params 参数（根据接口变化）
 @param success 成功回调
 @param failed 失败回调
 */
- (void)loginType:(LNLoginType)type param:(nullable NSDictionary *)params success:(WGUserLoginSuccessBlock)success failed:(WGUserFailedBlock)failed;

/**
 退出登录

 @param params 参数
 @param success 成功回调
 @param failed 失败回调
 */
- (void)logOut:(nullable NSDictionary *)params success:(nullable WGUserStringSuccessBlock)success failed:(nullable WGUserFailedBlock)failed;

/**
 获取验证码，根据 phoe_num
 
 @param params 参数（根据接口变化）
 @param success 成功回调
 @param failed 失败回调
 */
- (void)getSMSWithParam:(nullable NSDictionary *)params success:(WGUserStringSuccessBlock)success failed:(WGUserFailedBlock)failed;

/**
 绑定新手机号

 @param params 参数
 @param success 成功回调
 @param failed 失败回调
 */
- (void)bindPhoneWithParam:(nullable NSDictionary *)params success:(WGUserStringSuccessBlock)success failed:(WGUserFailedBlock)failed;

/**
 更新用户信息
 
 @param params 参数
 @param success 成功回调
 @param failed 失败回调
 */
- (void)updateUserInfoWithParam:(nullable NSDictionary *)params success:(WGUserStringSuccessBlock)success failed:(WGUserFailedBlock)failed;

/**
 更改密码

 @param params 参数
 @param success 成功回调
 @param failed 失败回调
 */
- (void)findPwd:(nullable NSDictionary *)params success:(WGUserLoginSuccessBlock)success failed:(WGUserFailedBlock)failed;

/**
 注册用户

 @param params 参数
 @param success 成功回调
 @param failed 失败回调
 */
- (void)registerWithParam:(nullable NSDictionary *)params success:(WGUserLoginSuccessBlock)success failed:(WGUserFailedBlock)failed;

/**
 刷新 token
 
 @param params 参数
 @param success 成功回调
 @param failed 失败回调
 */
- (void)refreshTokenSuccess:(WGUserStringSuccessBlock)success failed:(WGUserFailedBlock)failed;


/**
 获取位置信息

 @param completion 完成回调
 */
- (void)requestLocation:(nullable WGUserLoginSuccessBlock)completion;


/**
 获取最近的园区id

 @param completion 完成回调
 */
- (void)requestNearYard:(nullable WGUserLoginSuccessBlock)completion failed:(WGUserFailedBlock)failed;;

/**
 上传用户头像

 @param imgFileUrl 图片路径
 @param completion 成功完成回调
 @param failed 失败回调
 */
- (void)uploadUserHeadFileUrl:(NSURL *)imgFileUrl completion:(nullable WGUserLoginSuccessBlock)completion failed:(WGUserFailedBlock)failed;
@end

FOUNDATION_EXTERN NSString *const LNUserInfoDidChangeNotifactionName;
NS_ASSUME_NONNULL_END
