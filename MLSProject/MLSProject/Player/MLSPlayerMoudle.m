//
//  MLSPlayerMoudle.m
//  MLSProject
//
//  Created by MinLison on 2017/9/12.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSPlayerMoudle.h"
#import "MLSPlayerViewController.h"

@MOUDLE_REGISTER(MLSPlayerMoudle)
@implementation MLSPlayerMoudle
- (void)modSetUp:(BHContext *)context
{
        [AppShareRouterService addRoute:AppRoutePatternStringWithURI(kMLSPlayerViewControllerURI) handlerClass:[MLSPlayerViewController class]];
}
@end
