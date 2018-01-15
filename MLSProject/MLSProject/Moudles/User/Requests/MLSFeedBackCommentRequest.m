//
//  MLSFeedBackCommentRequest.m
//  MinLison
//
//  Created by MinLison on 2017/11/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSFeedBackCommentRequest.h"
#import "MLSFeedBackSendCommentRequest.h"
@implementation MLSFeedBackCommentRequest
- (instancetype)initWithParams:(NSDictionary *)params
{
        if (self = [super initWithParams:params]) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:WGFeedBackSendCommentSuccessNotifaction object:nil];
        }
        return self;
}

- (BOOL)contentIsArray
{
        return YES;
}

- (Class)contentType
{
        return [MLSFeedBackCommentModel class];
}

- (void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
