//
//  MLSUser.m
//  MinLison
//
//  Created by MinLison on 2017/9/22.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUser.h"
#import "Cache.h"
#import "UMLogin.h"
#import "MLSGetPhoneSMSRequest.h"
#import "MLSRefreshTokenRequest.h"
#import "MLSUpdateUserInfoRequest.h"
#import "MLSBindNewPhoneRequest.h"
#import "MLSPopLoginViewController.h"
#import "MLSUserGetNearYardRequest.h"
#import "MLSUserRegisterRequest.h"
#import "MLSUpdateUserInfoViewController.h"
#import "MLSFormLoginViewController.h"
#import "MLSUserFindPwdRequest.h"
#import "MLSPwdCondition.h"
#import "MLSPhoneCondition.h"
#import "MLSSMSCondition.h"
#import "MLSUploadImageRequest.h"
#define MLSUserLoginUserIdentifier @"MLSUserLoginUserIdentifier"
#define MLSLoginUserSettingIdentifier(user) [NSString stringWithFormat:@"MLSLoginUserSettingIdentifier_%@",user.uid]
#define MLSLoginGetSMSIdentifier @"MLSLoginGetSMSIdentifier"
#define MLSUserLoginFirstIdentifier @"MLSUserLoginFirstIdentifier"
#if (DEBUG)
NSInteger const kGetSMSCountTime = 60;
#else
NSInteger const kGetSMSCountTime = 60;
#endif
NSInteger const kGetSMSInitCountTime = 0;

@interface MLSUser ()<YYModel>
@property(nonatomic, assign, readwrite, getter=isLogin) BOOL login;
@property(nonatomic, assign, readwrite, getter=isLogout) BOOL logout;
@property(nonatomic, assign) NSUInteger lastGetSMSTimeInterval;
@property(nonatomic, assign, readwrite) BOOL canRegister;
@property(nonatomic, assign, readwrite) BOOL canLogin;
@property(nonatomic, assign, readwrite, getter=isFirstLogin) BOOL firstLogin;
@property(nonatomic, copy) WGUserLoginSuccessBlock userLoginSuccessBlock;
@property(nonatomic, copy) WGUserFailedBlock userLoginFailedBlock;
@property(nonatomic, assign, getter=isHandleUMMsg) BOOL handleUMMsg;
@property(nonatomic, strong) MLSUserGetNearYardRequest *getNearYardRequest;
@property(nonatomic, assign, getter=isReady) BOOL ready;
@property(nonatomic, assign, readwrite) BOOL canResetPassword;
@property(nonatomic, assign, readwrite) BOOL canFindPassword;
@end

@implementation MLSUser
@synthesize lastGetSMSTimeInterval = _lastGetSMSTimeInterval;
+ (instancetype)shareUser
{
        static dispatch_once_t onceToken;
        static MLSUser  *instance = nil;
        dispatch_once(&onceToken,^{
                instance = [[self alloc] init];
                [instance prepare];
        });
        return instance;
}

- (NSUInteger)lastGetSMSTimeInterval
{
        if (!_lastGetSMSTimeInterval) {
#if !(DEBUG)
                _lastGetSMSTimeInterval = [(NSNumber *)[ShareStaticCache objectForKey:MLSLoginGetSMSIdentifier] unsignedIntegerValue];
#endif
                if (_lastGetSMSTimeInterval <= 0) {
                        self.lastGetSMSTimeInterval = kGetSMSInitCountTime;
                }
        }
        return _lastGetSMSTimeInterval;
}
- (void)setLastGetSMSTimeInterval:(NSUInteger)lastGetSMSTimeInterval
{
        _lastGetSMSTimeInterval = lastGetSMSTimeInterval;
#if !(DEBUG)
        [ShareStaticCache setObject:@(lastGetSMSTimeInterval) forKey:MLSLoginGetSMSIdentifier];
#endif
}
- (BOOL)isLastSMSCountTimeCompletion
{
        return self.lastGetSMSTimeInterval == kGetSMSInitCountTime;
}
- (int)getSMSResidueCountTime
{
        NSUInteger current = (NSUInteger)[[NSDate date] timeIntervalSince1970];
        NSUInteger last = self.lastGetSMSTimeInterval;
        
        if (last == kGetSMSInitCountTime)
        {
                self.lastGetSMSTimeInterval = current;
                return kGetSMSCountTime;
        }
        int residueTime = (int)(kGetSMSCountTime - (current - last));
        if (residueTime <= 0) {
                self.lastGetSMSTimeInterval = kGetSMSInitCountTime;
                return kGetSMSCountTime;
        }
        return (int)MIN(residueTime, kGetSMSCountTime);
}
- (void)prepare
{
        @synchronized(self)
        {
                self.ready = NO;
                MLSUserModel *model = (MLSUserModel *)[ShareStaticCache objectForKey:MLSUserLoginUserIdentifier];
                if (model && [model isKindOfClass:[MLSUserModel class]])
                {
                        [self _UpdateWithUserModel:model];
                }
                else
                {
                        [self _UpdateWithUserModel:nil];
                }
                MLSUserSettingModel *settingModel = (MLSUserSettingModel *)[ShareStaticCache objectForKey:MLSLoginUserSettingIdentifier(model)];
                if (!settingModel) {
                        settingModel = [[MLSUserSettingModel alloc] init];
                        settingModel.enablePushNotifaction = YES;
                }
                self.userSetting = settingModel;
                
                self.lastGetSMSTimeInterval = kGetSMSInitCountTime;
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
                //        [self requestLocation:nil];
                self.ready = YES;
        }
        
}
- (BOOL)isUserInfoComplete
{
        if (!self.isReady) {
                return NO;
        }
        return self.isLogin && !self.isLogout && !NULLString(self.id_number) && !NULLString(self.name) && !NULLString(self.date) && !NULLString(self.mobile) && !NULLString(self.address) && !NULLString(self.email);
}

- (void)applicationWillTerminate
{
        [self _UpdateWithUserModel:self];
}
- (void)applicationDidReceiveMemoryWarning
{
        //        self.popLoginVC = nil;
}
- (void)applicationDidBecomeActive:(NSNotification *)noti
{
        if ((self.loginType == MLSLoginTypeQQ || self.loginType == MLSLoginTypeWebchat || self.loginType == MLSLoginTypeWeibo))
        {
                if (!self.isHandleUMMsg && self.userLoginFailedBlock)
                {
                        self.userLoginFailedBlock([NSError appErrorWithCode:APP_ERROR_CODE_ERR msg:[NSString app_AuthorizationFailed] remark:nil]);
                }
        }
        self.userLoginFailedBlock = nil;
        self.userLoginSuccessBlock = nil;
}
- (BOOL)isNeedModifyUserInfo
{
        return self.is_new_user && self.loginType == MLSLoginTypePhone;
}
- (void)_UpdateWithUserModel:(MLSUserModel *)userModel
{
        if (userModel == nil)
        {
                self.userSetting = nil;
                self.logout = YES;
                self.login = NO;
                [self modelSetWithJSON:[[[MLSUserModel alloc] init] jk_propertyDictionary]];
                [ShareStaticCache setObject:nil forKey:MLSUserLoginUserIdentifier];
                self.loginType = MLSLoginTypeUnKnown;
        }
        else if ( [userModel isKindOfClass:[MLSUserModel class]] && userModel != self)
        {
                self.logout = NO;
                self.login = YES;
                [self modelSetWithJSON:[userModel modelToJSONObject]];
                self.old_nickname = userModel.nickname;
                [self modelSetWithJSON:[userModel jk_propertyDictionary]];
                [ShareStaticCache setObject:self forKey:MLSUserLoginUserIdentifier];
        }
        
        
        
        [self _JudgeKVOState];
        
}
/// MARK: - Public Method
- (void)popLoginInViewController:(nullable UIViewController *)viewController completion:(nullable void (^)(void))completion dismiss:(nullable void (^)(void))dismiss
{
        [[[MLSPopLoginViewController alloc] initWithType:(WGPopLoginTypeBottomSheet)] presentInViewController:viewController completion:completion dismiss:dismiss];
}
- (void)popLoginIfNeedInViewController:(nullable UIViewController *)viewController completion:(nullable void (^)(void))completion dismiss:(nullable void (^)(void))dismiss
{
        if (self.isLogin && !self.isLogout)
        {
                if (completion) {
                        completion();
                }
                if (dismiss) {
                        dismiss();
                }
        }
        else
        {
                [self popLoginInViewController:viewController completion:completion dismiss:dismiss];
        }
}
- (void)pushOrPresentLoginIfNeed:(BOOL)ifNeed inViewController:(nullable UIViewController *)viewController completion:(nullable void (^)(void))completion dismiss:(nullable void (^)(void))dismiss
{
        MLSFormLoginViewController *vc = [[MLSFormLoginViewController alloc] init];
        if (!ifNeed || !self.isLogin || self.isLogout)
        {
                vc.dismissBlock = dismiss;
                [vc presentOrPushInViewController:viewController?:__KEY_WINDOW__.rootViewController];
        }
        else
        {
                if (completion) {
                        completion();
                }
                if (dismiss) {
                        dismiss();
                }
        }
}
- (void)pushOrPresentUserInfoInViewController:(nullable UIViewController *)viewController completion:(nullable void (^)(void))completion dismiss:(nullable void (^)(void))dismiss
{
        if (self.isLogin)
        {
                [[[MLSUpdateUserInfoViewController alloc] init] presentOrPushInViewController:viewController dismiss:dismiss];
        }
        else
        {
                [self popLoginIfNeedInViewController:viewController completion:^{
                        
                } dismiss:^{
                        if (self.isLogin)
                        {
                                [[[MLSUpdateUserInfoViewController alloc] init] presentOrPushInViewController:viewController dismiss:dismiss];
                        }
                }];
        }
}
- (void)pushOrPresentUserInfoIfNeedInViewController:(nullable UIViewController *)viewController completion:(nullable void (^)(void))completion dismiss:(nullable void (^)(void))dismiss
{
        if (self.userInfoComplete)
        {
                if (completion)
                {
                        completion();
                }
                if (dismiss)
                {
                        dismiss();
                }
        }
        else
        {
                [self pushOrPresentUserInfoInViewController:viewController completion:completion dismiss:dismiss];
        }
}
- (void)loginType:(MLSLoginType)type param:(nullable NSDictionary *)params success:(WGUserLoginSuccessBlock)success failed:(WGUserFailedBlock)failed
{
        self.loginType = type;
        if (self.loginType == MLSLoginTypePhone)
        {
                [self loginWithPhoneParam:params success:success failed:failed];
        }
        else
        {
                [self loginWithThirdPartyType:self.loginType success:success failed:failed];
        }
}
- (void)logOut:(nullable NSDictionary *)params success:(nullable WGUserStringSuccessBlock)success failed:(nullable WGUserFailedBlock)failed
{
        [self _UpdateWithUserModel:nil];
        if (success) {
                success([NSString aPP_LogoutSuccess]);
        }
}
- (void)loginWithPhoneParam:(NSDictionary *)params success:(WGUserLoginSuccessBlock)success failed:(WGUserFailedBlock)failed
{
        MLSUserPhoneLoginRequest *phoneLoginReq = [MLSUserPhoneLoginRequest requestWithParams:params];
        [self _InsertParamsForRequest:phoneLoginReq];
        
        [phoneLoginReq startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof MLSUserModel * _Nonnull data) {
                [self _UpdateWithUserModel:data];
                if (success) {
                        success(data);
                }
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                if (failed) {
                        failed(error);
                }
        }];
}
- (void)loginWithThirdPartyType:(MLSLoginType)type success:(WGUserLoginSuccessBlock)success failed:(WGUserFailedBlock)failed
{
        self.userLoginSuccessBlock = success;
        self.userLoginFailedBlock = failed;
        @weakify(self);
        [UMLogin login:(UMLoginType)type completion:^(BOOL suc, NSError *err, NSDictionary *response) {
                @strongify(self);
                self.handleUMMsg = YES;
                self.loginType = MLSLoginTypeUnKnown;
                if (success)
                {
                        NSDictionary *params = @{
                                                 kRequestKeyType : @(type),
                                                 kRequestKeyThird_Party_Id : NOT_NULL_STRING_DEFAULT_EMPTY([response jk_stringForKey:@"usid"]),
                                                 kRequestKeyAvatar :NOT_NULL_STRING_DEFAULT_EMPTY([response jk_stringForKey:@"iconurl"]),
                                                 kRequestKeyNick_Name : NOT_NULL_STRING_DEFAULT_EMPTY([response jk_stringForKey:@"name"])
                                                 };
                        MLSUserThirdLoginRequest *thirdLoginReq = [MLSUserThirdLoginRequest requestWithParams:params];
                        
                        [thirdLoginReq startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof MLSUserModel * _Nonnull data) {
                                [self _UpdateWithUserModel:data];
                                if (success) {
                                        success(data);
                                }
                        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                                if (failed) {
                                        failed(error);
                                }
                        }];
                }
                else
                {
                        if (failed)
                        {
                                failed(err);
                        }
                }
        }];
        
}

- (void)getSMSWithParam:(nullable NSDictionary *)params success:(WGUserStringSuccessBlock)success failed:(WGUserFailedBlock)failed
{
        MLSGetPhoneSMSRequest *smsReq = [MLSGetPhoneSMSRequest requestWithParams:params];
        if (![params jk_stringForKey:kRequestKeyMobile])
        {
                [smsReq paramInsert:self.mobile forKey:kRequestKeyMobile];
        }
        
        [smsReq startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof NSString * _Nonnull data) {
                if (success)
                {
                        success([data isKindOfClass:[NSString class]] ? data : request.tipString);
                }
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                if (failed)
                {
                        failed(error);
                }
        }];
}
- (void)bindPhoneWithParam:(nullable NSDictionary *)params success:(WGUserStringSuccessBlock)success failed:(WGUserFailedBlock)failed
{
        MLSBindNewPhoneRequest *request = [MLSBindNewPhoneRequest requestWithParams:params];
        [self _InsertParamsForRequest:request];
        
        [request startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof MLSUserModel *  _Nonnull data) {
                [self _UpdateWithUserModel:data];
                if (success)
                {
                        success(request.tipString);
                }
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                if (failed)
                {
                        failed(error);
                }
        }];
}

- (void)updateUserInfoWithParam:(nullable NSDictionary *)params success:(WGUserStringSuccessBlock)success failed:(WGUserFailedBlock)failed
{
        MLSUpdateUserInfoRequest *request = [MLSUpdateUserInfoRequest requestWithParams:params];
        
        [self _InsertParamsForRequest:request];
        
        [request startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof MLSUserModel * _Nonnull data) {
                [self _UpdateWithUserModel:data];
                if (success)
                {
                        success(request.tipString);
                }
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                if (failed)
                {
                        failed(error);
                }
        }];
}
- (void)findPwd:(nullable NSDictionary *)params success:(WGUserLoginSuccessBlock)success failed:(WGUserFailedBlock)failed
{
        MLSUserFindPwdRequest *request = [MLSUserFindPwdRequest requestWithParams:params];
        [self _InsertParamsForRequest:request];
        [request startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof MLSUserModel * _Nonnull data) {
                [self _UpdateWithUserModel:data];
                if (success)
                {
                        success(self);
                }
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                if (failed)
                {
                        failed(error);
                }
        }];
}
- (void)registerWithParam:(nullable NSDictionary *)params success:(WGUserLoginSuccessBlock)success failed:(WGUserFailedBlock)failed
{
        MLSUserRegisterRequest *request = [MLSUserRegisterRequest requestWithParams:params];
        [self _InsertParamsForRequest:request];
        [request startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof MLSUserModel * _Nonnull data) {
                [self _UpdateWithUserModel:data];
                if (success) {
                        success(self);
                }
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                if (failed) {
                        failed(error);
                }
        }];
}
- (void)refreshTokenSuccess:(WGUserStringSuccessBlock)success failed:(WGUserFailedBlock)failed
{
        MLSRefreshTokenRequest *request = [MLSRefreshTokenRequest requestWithParams:nil];
        [self _InsertParamsForRequest:request];
        [request startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof NSString * _Nonnull data) {
                if (success)
                {
                        success(data);
                }
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                if (failed)
                {
                        failed(error);
                }
        }];
}
- (void)requestLocation:(WGUserLoginSuccessBlock)completion
{
        
}
- (void)requestNearYard:(nullable WGUserLoginSuccessBlock)completion failed:(WGUserFailedBlock)failed
{
        [self requestLocation:^(MLSUserModel * _Nonnull user) {
                self.getNearYardRequest = [MLSUserGetNearYardRequest requestWithParams:nil];
                [self.getNearYardRequest startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof MLSYardModel * _Nonnull data) {
                        self.currentYardModel = data;
                        if (completion) {
                                completion(self);
                        }
                } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                        if (failed) {
                                failed(error);
                        }
                }];
        }];
}
- (void)uploadUserHeadFileUrl:(NSURL *)imgFileUrl completion:(nullable WGUserLoginSuccessBlock)completion failed:(WGUserFailedBlock)failed
{
        MLSUploadImageRequest *uploadImgRequest = [[MLSUploadImageRequest alloc] initWithImgFileUrl:imgFileUrl];
        @weakify(self);
        [uploadImgRequest startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof MLSUploadImgModel * _Nonnull data) {
                @strongify(self);
                [SDWebImageManager.sharedManager saveImageToCache:[UIImage imageWithContentsOfFile:imgFileUrl.absoluteString] forURL:[NSURL URLWithString:NOT_NULL_STRING_DEFAULT_EMPTY(data.url)]];
                self.img = data.url;
                [self updateUserInfoWithParam:@{
                                                kRequestKeyImg : NOT_NULL_STRING_DEFAULT_EMPTY(data.url)
                                                } success:^(NSString * _Nonnull sms) {
                                                        if (completion) {
                                                                completion(self);
                                                        }
                                                } failed:^(NSError * _Nonnull error) {
                                                        if (failed) {
                                                                failed(error);
                                                        }
                                                }];
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                if (failed) {
                        failed(error);
                }
        }];
}
- (void)_InsertParamsForRequest:(BaseRequest *)request
{
        NSDictionary *dict = (NSDictionary *)[self modelToJSONObject];
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if (!NULLObject(obj) && ![request.params objectForKey:key])
                {
                        [request paramInsert:obj forKey:key];
                }
        }];
}

/// MARK: - KVO


- (void)setPhone:(NSString *)mobile
{
        [super setMobile:mobile];
        [self _JudgeKVOState];
        [self postUserInfoDidChangeNotifaction];
}

- (void)setNickname:(NSString *)nickname
{
        [super setNickname:nickname];
        [self postUserInfoDidChangeNotifaction];
}

- (void)setImg:(NSString *)img
{
        [super setImg:img];
        [self postUserInfoDidChangeNotifaction];
}

- (void)setCountry_code:(NSString *)country_code
{
        [super setCountry_code:country_code];
        [self _JudgeKVOState];
}
- (void)setCheckAgreement:(BOOL)checkAgreement
{
        if (_checkAgreement != checkAgreement) {
                [self willChangeValueForKey:@keypath(self,checkAgreement)];
                _checkAgreement = checkAgreement;
                [self didChangeValueForKey:@keypath(self,checkAgreement)];
                [self _JudgeKVOState];
        }
}
- (void)setSms_code:(NSString *)sms_code
{
        if (_sms_code != sms_code) {
                [self willChangeValueForKey:@keypath(self,sms_code)];
                _sms_code = sms_code;
                [self didChangeValueForKey:@keypath(self,sms_code)];
                [self _JudgeKVOState];
        }
}
- (void)setCanResetPassword:(BOOL)canResetPassword
{
        if (_canResetPassword != canResetPassword) {
                [self willChangeValueForKey:@keypath(self,canResetPassword)];
                _canResetPassword = canResetPassword;
                [self didChangeValueForKey:@keypath(self,canResetPassword)];
        }
}
- (void)setCanFindPassword:(BOOL)canFindPassword
{
        if (_canFindPassword != canFindPassword) {
                [self willChangeValueForKey:@keypath(self,canFindPassword)];
                _canFindPassword = canFindPassword;
                [self didChangeValueForKey:@keypath(self,canFindPassword)];
        }
}

- (void)_JudgeKVOState
{
        if (!self.isReady)
        {
                self.canRegister = NO;
                self.canLogin = NO;
                return;
        }
        self.canRegister = [[MLSPhoneCondition condition] check:self.mobile] && [[MLSSMSCondition condition] check:self.sms_code] && !NULLString(self.country_code) && !self.isLogin && self.isLogout && [[MLSPwdCondition condition] check:self.password];
        self.canLogin = [[MLSPhoneCondition condition] check:self.mobile] && [[MLSPwdCondition condition] check:self.password] && !NULLString(self.country_code) && !self.isLogin && self.isLogout;
        self.canResetPassword = self.isLogin && !self.isLogout && [[MLSPwdCondition condition] check:self.old_password] && [[MLSPwdCondition condition] check:self.password] && [[MLSPwdCondition condition] check:self.repeat_password] && [self.password isEqualToString:self.repeat_password];
        self.canFindPassword = !self.isLogin && self.isLogout && [[MLSPwdCondition condition] check:self.password];
}
- (void)postUserInfoDidChangeNotifaction
{
        self.userInfoDidChange = NO;
        self.userInfoDidChange = YES;
        NSNotification *noti = [[NSNotification alloc] initWithName:MLSUserInfoDidChangeNotifactionName object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
}

//===========================================================
// + (BOOL)automaticallyNotifiesObserversForKey:
//
//===========================================================
+ (BOOL)automaticallyNotifiesObserversForKey: (NSString *)theKey
{
        BOOL automatic;
        
        if ([theKey isEqualToString:@keypath(MLSUserManager,login)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,logout)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,canRegister)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,canLogin)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,userInfoDidChange)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,password)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,mobile)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,repeat_password)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,sms_code)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,checkAgreement)]) {
                automatic = NO;
        } else {
                automatic = [super automaticallyNotifiesObserversForKey:theKey];
        }
        return automatic;
}

- (void)setPassword:(NSString *)password
{
        if (_password != password) {
                [self willChangeValueForKey:@keypath(self,password)];
                _password = password;
                [self didChangeValueForKey:@keypath(self,password)];
                [self _JudgeKVOState];
        }
}
- (void)setRepeat_password:(NSString *)repeat_password
{
        if (_repeat_password != repeat_password) {
                [self willChangeValueForKey:@keypath(self,repeat_password)];
                _repeat_password = repeat_password;
                [self didChangeValueForKey:@keypath(self,repeat_password)];
                [self _JudgeKVOState];
        }
}
- (void)setUserInfoDidChange:(BOOL)userInfoDidChange
{
        [self willChangeValueForKey:@keypath(self,userInfoDidChange)];
        _userInfoDidChange = userInfoDidChange;
        [self didChangeValueForKey:@keypath(self,userInfoDidChange)];
}
- (void)setLogin:(BOOL)flag
{
        if (_login != flag) {
                [self willChangeValueForKey:@keypath(self,login)];
                _login = flag;
                [self didChangeValueForKey:@keypath(self,login)];
                [self postUserInfoDidChangeNotifaction];
        }
}
- (void)setLogout:(BOOL)flag
{
        if (_logout != flag) {
                [self willChangeValueForKey:@keypath(self,logout)];
                _logout = flag;
                [self didChangeValueForKey:@keypath(self,logout)];
                [self postUserInfoDidChangeNotifaction];
        }
}
- (void)setCanRegister:(BOOL)flag
{
        if (_canRegister != flag) {
                [self willChangeValueForKey:@keypath(self,canRegister)];
                _canRegister = flag;
                [self didChangeValueForKey:@keypath(self,canRegister)];
        }
}
- (void)setCanLogin:(BOOL)flag
{
        if (_canLogin != flag) {
                [self willChangeValueForKey:@keypath(self,canLogin)];
                _canLogin = flag;
                [self didChangeValueForKey:@keypath(self,canLogin)];
        }
}
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @keypath(MLSUserManager,sms_code) : @[@"code"]
                                                                                      }];
        if ([[self superclass] respondsToSelector:@selector(modelCustomPropertyMapper)])
        {
                NSDictionary *dict = [[self superclass] modelCustomPropertyMapper];
                if (dict)
                {
                        [dictM addEntriesFromDictionary:dict];
                }
                
        }
        
        return dictM;
}
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
        MLSUser *user = nil;
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @keypath(user,userSetting) : [MLSUserSettingModel class],
                                                                                      }];
        if ([[self superclass] respondsToSelector:@selector(modelContainerPropertyGenericClass)])
        {
                NSDictionary *dict = [[self superclass] modelContainerPropertyGenericClass];
                if (dict)
                {
                        [dictM addEntriesFromDictionary:dict];
                }
                
        }
        return dictM;
}
+ (NSArray<NSString *> *)modelPropertyBlacklist
{
        MLSUser *user = nil;
        return @[@keypath(user,old_nickname),
                  @keypath(user,login),
                  @keypath(user,logout),
                  @keypath(user,canLogin),
                  @keypath(user,canRegister),
                  @keypath(user,lastGetSMSTimeInterval),
                  @keypath(user,loginType),
                  @keypath(user,needModifyUserInfo),
                  @keypath(user,userLoginFailedBlock),
                  @keypath(user,userLoginSuccessBlock),
                  @keypath(user,userSetting),
                  @keypath(user,currentYardModel),
                  @keypath(user,repeat_password),
                  @keypath(user,handleUMMsg),
                  @keypath(user,userInfoComplete),
                  @keypath(user,userInfoDidChange),
                  @keypath(user,firstLogin),
                  @keypath(user,checkAgreement),
                  @keypath(user,getNearYardRequest),
                  @keypath(user,ready),
                  //                  @keypath(user,popLoginVC),
                  ];
}

+ (NSDictionary *)jk_codableProperties
{
        NSDictionary *dict = [super jk_codableProperties];
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:dict];
        [dictM removeObjectsForKeys:[self modelPropertyBlacklist]];
        return dictM;
}

@end
NSString *const MLSUserInfoDidChangeNotifactionName = @"MLSUserInfoDidChangeNotifactionName";
