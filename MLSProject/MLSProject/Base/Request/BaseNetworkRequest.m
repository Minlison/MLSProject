//
//  BaseNetworkRequest.m
//  MLSProject
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseNetworkRequest.h"

static NSUInteger networkTag = 0;
@implementation BaseNetworkRequest
- (instancetype)init
{
        self = [super init];
        if (self) {
                self.tag = networkTag++;
        }
        return self;
}

@end
