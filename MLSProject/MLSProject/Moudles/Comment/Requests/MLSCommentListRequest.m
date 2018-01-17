//
//  MLSCommentListRequest.m
//  MinLison
//
//  Created by minlison on 2017/10/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSCommentListRequest.h"
#import "MLSSendCommentRequest.h"
@implementation MLSCommentListRequest
- (instancetype)initWithParams:(NSDictionary *)params
{
        if (self = [super initWithParams:params]) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:WGWGSendCommentSuccessNotifaction object:nil];
        }
        return self;
}
- (BOOL)contentIsArray
{
        return YES;
}

- (Class)contentType
{
        return [MLSCommentModel class];
}

- (void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
