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

        if ([theKey isEqualToString:@keypath(LNUserManager,uid)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(LNUserManager,mobile)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(LNUserManager,nickname)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(LNUserManager,img)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(LNUserManager,role)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(LNUserManager,token)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(LNUserManager,refresh_token)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(LNUserManager,country_code)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(LNUserManager,id_number)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(LNUserManager,date)]) {
                automatic = NO;
        } else {
                automatic = [super automaticallyNotifiesObserversForKey:theKey];
        }

        return automatic;
}
- (void)setId_number:(NSString *)id_number
{
        if (_id_number != id_number) {
                [self willChangeValueForKey:@keypath(LNUserManager,id_number)];
                _id_number = [id_number copy];
                self.date = [CoBaseUtils isIDNumber:id_number withDateFmt:@"yyyy-MM-dd"];
                [self didChangeValueForKey:@keypath(LNUserManager,id_number)];
        }
}
- (void)setDate:(NSString *)date
{
        if (_date != date) {
                [self willChangeValueForKey:@keypath(LNUserManager,date)];
                _date = [date copy];
                [self didChangeValueForKey:@keypath(LNUserManager,date)];
        }
}
//===========================================================
// - setUser_id:
//===========================================================
- (void)setUid:(NSString *)uid
{
        if (_uid != uid) {
                [self willChangeValueForKey:@keypath(LNUserManager,uid)];
                _uid = [uid copy];
                [self didChangeValueForKey:@keypath(LNUserManager,uid)];
        }
}
//===========================================================
// - setPhone:
//===========================================================
- (void)setMobile:(NSString *)mobile
{
        if (_mobile != mobile) {
                [self willChangeValueForKey:@keypath(LNUserManager,mobile)];
                _mobile = [mobile copy];
                [self didChangeValueForKey:@keypath(LNUserManager,mobile)];
        }
}

//===========================================================
// - setNick_name:
//===========================================================
- (void)setNick_name:(NSString *)aNick_name
{
        if (_nickname != aNick_name) {
                [self willChangeValueForKey:@keypath(LNUserManager,nickname)];
                _nickname = [aNick_name copy];
                [self didChangeValueForKey:@keypath(LNUserManager,nickname)];
        }
}

//===========================================================
// - setAvatar:
//===========================================================
- (void)setAvatar:(NSString *)anAvatar
{
        if (_img != anAvatar) {
                [self willChangeValueForKey:@keypath(LNUserManager,img)];
                _img = [anAvatar copy];
                [self didChangeValueForKey:@keypath(LNUserManager,img)];
        }
}

//===========================================================
// - setRole:
//===========================================================
- (void)setRole:(NSString *)aRole
{
        if (_role != aRole) {
                [self willChangeValueForKey:@keypath(LNUserManager,role)];
                _role = [aRole copy];
                [self didChangeValueForKey:@keypath(LNUserManager,role)];
        }
}
//===========================================================
// - setToken:
//===========================================================
- (void)setToken:(NSString *)aToken
{
        if (_token != aToken) {
                [self willChangeValueForKey:@keypath(LNUserManager,token)];
                _token = [aToken copy];
                [self didChangeValueForKey:@keypath(LNUserManager,token)];
        }
}
//===========================================================
// - setRefresh_token:
//===========================================================
- (void)setRefresh_token:(NSString *)aRefresh_token
{
        if (_refresh_token != aRefresh_token) {
                [self willChangeValueForKey:@keypath(LNUserManager,refresh_token)];
                _refresh_token = [aRefresh_token copy];
                [self didChangeValueForKey:@keypath(LNUserManager,refresh_token)];
        }
}
//===========================================================
// - setCountry_code:
//===========================================================
- (void)setCountry_code:(NSString *)aCountry_code
{
        if (_country_code != aCountry_code) {
                [self willChangeValueForKey:@keypath(LNUserManager,country_code)];
                _country_code = [aCountry_code copy];
                [self didChangeValueForKey:@keypath(LNUserManager,country_code)];
        }
}


@end
