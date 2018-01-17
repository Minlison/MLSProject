//
//  MLSSendCommentRequest.m
//  MinLison
//
//  Created by minlison on 2017/10/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSSendCommentRequest.h"

@implementation MLSSendCommentRequest

- (Class)contentType
{
        return [MLSCommentModel class];
}

- (void)requestSuccess
{
        NSNotification *noti = [[NSNotification alloc] initWithName:WGWGSendCommentSuccessNotifaction object:self.serverRootModel.modelContent userInfo:self.request.decryptResponseObject];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
}
- (BOOL)needCache
{
        return NO;
}
@end
NSString *WGWGSendCommentSuccessNotifaction = @"WGWGSendCommentSuccessNotifaction";
