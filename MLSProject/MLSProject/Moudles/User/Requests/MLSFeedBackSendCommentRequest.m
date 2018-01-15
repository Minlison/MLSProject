//
//  MLSFeedBackSendCommentRequest.m
//  MinLison
//
//  Created by MinLison on 2017/11/9.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSFeedBackSendCommentRequest.h"

@implementation MLSFeedBackSendCommentRequest
- (BOOL)contentIsArray
{
        return NO;
}
- (Class)contentType
{
        return [MLSFeedBackCommentModel class];
}
- (BOOL)needCache
{
        return NO;
}

- (void)requestSuccess
{
        NSNotification *noti = [[NSNotification alloc] initWithName:WGFeedBackSendCommentSuccessNotifaction object:self.serverRootModel.modelContent userInfo:self.request.decryptResponseObject];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
}
@end
NSString *WGFeedBackSendCommentSuccessNotifaction = @"WGFeedBackSendCommentSuccessNotifaction";
