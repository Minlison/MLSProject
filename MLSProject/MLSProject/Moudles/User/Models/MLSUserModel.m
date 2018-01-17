//
//  MLSUserModel.m
//  MinLison
//
//  Created by MinLison on 2017/9/22.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserModel.h"

@implementation MLSUserModel
@synthesize nickname = _nickname;
@synthesize country_code = _country_code;
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
//        MLSUserModel *model;
        return @{
                 };
}
- (NSString *)gender
{
        if (NULLString(_gender)) {
                _gender = @"保密";
        }
        return _gender;
}

- (NSString *)country_code
{
        if (!_country_code) {
                _country_code = @"86";
        }
        return _country_code;
}

//===========================================================
// + (BOOL)automaticallyNotifiesObserversForKey:
//
//===========================================================
+ (BOOL)automaticallyNotifiesObserversForKey: (NSString *)theKey
{
        BOOL automatic;

        if ([theKey isEqualToString:@keypath(MLSUserManager,uid)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,mobile)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,nickname)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,img)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,role)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,token)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,refresh_token)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,country_code)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,id_number)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(MLSUserManager,date)]) {
                automatic = NO;
        } else {
                automatic = [super automaticallyNotifiesObserversForKey:theKey];
        }

        return automatic;
}
- (void)setId_number:(NSString *)id_number
{
        if (_id_number != id_number) {
                [self willChangeValueForKey:@keypath(MLSUserManager,id_number)];
                _id_number = [id_number copy];
                self.date = [CoBaseUtils isIDNumber:id_number withDateFmt:@"yyyy-MM-dd"];
                [self didChangeValueForKey:@keypath(MLSUserManager,id_number)];
        }
}
- (void)setDate:(NSString *)date
{
        if (_date != date) {
                [self willChangeValueForKey:@keypath(MLSUserManager,date)];
                _date = [date copy];
                [self didChangeValueForKey:@keypath(MLSUserManager,date)];
        }
}
//===========================================================
// - setUser_id:
//===========================================================
- (void)setUid:(NSString *)uid
{
        if (_uid != uid) {
                [self willChangeValueForKey:@keypath(MLSUserManager,uid)];
                _uid = [uid copy];
                [self didChangeValueForKey:@keypath(MLSUserManager,uid)];
        }
}
//===========================================================
// - setPhone:
//===========================================================
- (void)setMobile:(NSString *)mobile
{
        if (_mobile != mobile) {
                [self willChangeValueForKey:@keypath(MLSUserManager,mobile)];
                _mobile = [mobile copy];
                [self didChangeValueForKey:@keypath(MLSUserManager,mobile)];
        }
}

//===========================================================
// - setNick_name:
//===========================================================
- (void)setNick_name:(NSString *)aNick_name
{
        if (_nickname != aNick_name) {
                [self willChangeValueForKey:@keypath(MLSUserManager,nickname)];
                _nickname = [aNick_name copy];
                [self didChangeValueForKey:@keypath(MLSUserManager,nickname)];
        }
}

//===========================================================
// - setAvatar:
//===========================================================
- (void)setAvatar:(NSString *)anAvatar
{
        if (_img != anAvatar) {
                [self willChangeValueForKey:@keypath(MLSUserManager,img)];
                _img = [anAvatar copy];
                [self didChangeValueForKey:@keypath(MLSUserManager,img)];
        }
}

//===========================================================
// - setRole:
//===========================================================
- (void)setRole:(NSString *)aRole
{
        if (_role != aRole) {
                [self willChangeValueForKey:@keypath(MLSUserManager,role)];
                _role = [aRole copy];
                [self didChangeValueForKey:@keypath(MLSUserManager,role)];
        }
}
//===========================================================
// - setToken:
//===========================================================
- (void)setToken:(NSString *)aToken
{
        if (_token != aToken) {
                [self willChangeValueForKey:@keypath(MLSUserManager,token)];
                _token = [aToken copy];
                [self didChangeValueForKey:@keypath(MLSUserManager,token)];
        }
}
//===========================================================
// - setRefresh_token:
//===========================================================
- (void)setRefresh_token:(NSString *)aRefresh_token
{
        if (_refresh_token != aRefresh_token) {
                [self willChangeValueForKey:@keypath(MLSUserManager,refresh_token)];
                _refresh_token = [aRefresh_token copy];
                [self didChangeValueForKey:@keypath(MLSUserManager,refresh_token)];
        }
}
//===========================================================
// - setCountry_code:
//===========================================================
- (void)setCountry_code:(NSString *)aCountry_code
{
        if (_country_code != aCountry_code) {
                [self willChangeValueForKey:@keypath(MLSUserManager,country_code)];
                _country_code = [aCountry_code copy];
                [self didChangeValueForKey:@keypath(MLSUserManager,country_code)];
        }
}


@end
