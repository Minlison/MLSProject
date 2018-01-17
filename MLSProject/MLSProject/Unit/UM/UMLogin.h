//
//  UMLogin.h
//  MinLison
//
//  Created by MinLison on 2017/11/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, UMLoginType)
{
        UMLoginTypeUnkKnown = 0,
        UMLoginTypeQQ       = MLSLoginTypeQQ,
        UMLoginTypeWeiXin   = MLSLoginTypeWebchat,
        UMLoginTypeWeiBo    = MLSLoginTypeWeibo,
};
typedef void(^UMLoginCompletionBlock)(BOOL success, NSError * _Nullable error, NSDictionary * _Nullable response);
@interface UMLogin : NSObject
/**
 三方登录
 
 @param type 登录类型
 @param completion 完成回调
 */
+ (void)login:(UMLoginType)type completion:(UMLoginCompletionBlock)completion;
@end
NS_ASSUME_NONNULL_END
