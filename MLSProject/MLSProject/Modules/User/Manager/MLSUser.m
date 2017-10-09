//
//  MLSUser.m
//  MLSProject
//
//  Created by MinLison on 2017/10/09.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUser.h"
#import "Cache.h"
#define MLSUserListIdentifier @"MLSUserListIdentifier"
#define MLSUserLastLoginModelKeyIdentifier @"MLSUserLastLoginModelKeyIdentifier"

@interface MLSUser ()
@property(nonatomic, strong) NSMutableDictionary <NSString *,MLSUserModel *>* userList;
@end

@implementation MLSUser
+ (instancetype)shareUser {
        static dispatch_once_t onceToken;
        static MLSUser  *instance = nil;
        dispatch_once(&onceToken,^{
                instance = [[self alloc] init];
        });
        return instance;
}

- (void)setUserModel:(MLSUserModel *)userModel
{
        _userModel = userModel;
        if (userModel == nil)
        {
                [ShareStaticCache removeObjectForKey:MLSUserLastLoginModelKeyIdentifier];
        }
        else
        {
                NSString *key = [NSString stringWithFormat:@"%@_%@",MLSUserListIdentifier,userModel.user_id];
                [self.userList setObject:userModel forKey:key];
                [self saveUserLists];
        }
}
- (void)saveUserLists
{
        [ShareStaticCache setObject:self.userList forKey:MLSUserListIdentifier];
}
- (NSMutableDictionary <NSString *,MLSUserModel *>*)userList
{
        if(_userList == nil)
        {
                _userList = (NSMutableDictionary <NSString *,MLSUserModel *>*)[ShareStaticCache objectForKey:MLSUserListIdentifier];
                NSString *key = (NSString *)[ShareStaticCache objectForKey:MLSUserLastLoginModelKeyIdentifier];
                if (key != nil)
                {
                        _userModel = [_userList objectForKey:key];
                }
        }
        return _userList;
}

/// MARK: - Getter
- (NSString *)user_id
{
        return self.userModel.user_id ?:@"0";
}
@end
