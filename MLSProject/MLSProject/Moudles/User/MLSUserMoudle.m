//
//  MLSUserMoudle.m
//  MinLison
//
//  Created by MinLison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserMoudle.h"
#import "MainMoudle.h"
#import "BaseNavigationViewController.h"
#import "MLSUserViewController.h"
#import "MLSUpdateUserInfoViewController.h"
@MOUDLE_REGISTER(MLSUserMoudle)

@implementation MLSUserMoudle
- (void)modSetUp:(BHContext *)context
{
        [AppShareRouterService addRoute:kMLSUpdateUserInfoControllerURI handlerClass:[MLSUpdateUserInfoViewController class]];
}

@end
