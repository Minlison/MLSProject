//
//  BaseRequestEngine.m
//  MinLison
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseRequestEngine.h"

@interface BaseRequestEngine ()
@property(nonatomic, strong) NSMutableDictionary *requests;
@end

@implementation BaseRequestEngine
+ (instancetype)sharedInstance {
        static dispatch_once_t onceToken;
        static BaseRequestEngine  *instance = nil;
        dispatch_once(&onceToken,^{
                instance = [[self alloc] init];
                instance.requests = [NSMutableDictionary dictionary];
        });
        return instance;
}

- (void)startRequest:(__kindof BaseRequest *)request
{
        [self.requests setObject:request forKey:request.uuid];
}
- (void)finishRequest:(__kindof BaseRequest *)request
{
        [self.requests removeObjectForKey:request.uuid];
}

+ (void)startRequest:(__kindof BaseRequest *)request
{
        [[self sharedInstance] startRequest:request];
}
+ (void)finishRequest:(__kindof BaseRequest *)request
{
        [[self sharedInstance] finishRequest:request];
}
@end
