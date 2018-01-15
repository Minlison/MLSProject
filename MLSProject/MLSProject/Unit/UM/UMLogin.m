//
//  UMLogin.m
//  MinLison
//
//  Created by MinLison on 2017/11/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "UMLogin.h"

@implementation UMLogin
+ (void)login:(UMLoginType)type completion:(UMLoginCompletionBlock)completion
{
        UMSocialPlatformType platform = UMSocialPlatformType_UnKnown;
        switch (type) {
                case UMLoginTypeWeiBo:
                        platform = UMSocialPlatformType_Sina;
                        break;
                case UMLoginTypeQQ:
                        platform = UMSocialPlatformType_QQ;
                        break;
                case UMLoginTypeWeiXin:
                        platform = UMSocialPlatformType_WechatSession;
                        break;
                        
                default:
                        break;
        }
        
        [self getUserInfoForPlatform:platform LoginType:type completion:completion];
}


+ (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType LoginType:(UMLoginType)type completion:(UMLoginCompletionBlock)completion
{
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
                if (!error && [result isKindOfClass:[UMSocialUserInfoResponse class]])
                {
                        UMSocialUserInfoResponse *userinfo =result;
                        
                        if (completion)
                        {
                                completion(YES, nil, [userinfo modelToJSONObject]);
                        }
                        
                }
                else if (completion)
                {
                        completion(NO,[NSError appErrorWithCode:APP_ERROR_CODE_ERR msg:[NSString app_AuthorizationFailed] remark:error.localizedDescription],nil);
                }
        }];
}

@end
