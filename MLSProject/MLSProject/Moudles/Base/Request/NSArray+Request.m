//
//  NSArray+Request.m
//  MinLison
//
//  Created by MinLison on 2017/9/22.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "NSArray+Request.h"
#import "BaseRequest.h"

@interface BaseRequest (Prv)
- (void)groupInterSuccess:(RequestSuccessBlock)success failed:(RequestFailedBlock)failed;
@end

@implementation NSArray (Request)
@extSynthesizeAssociation(NSArray, sync);
- (void)startSync:(BOOL)sync requestWithSuccess:(GroupRequestSuccessBlock)success failed:(GroupRequestFailedBlock)failed
{
        self.sync = sync;
        [self startRequestWithSuccess:success failed:failed];
}
- (void)startRequestWithSuccess:(GroupRequestSuccessBlock)success failed:(GroupRequestFailedBlock)failed
{
        if (self.sync)
        {
                [self _startOrderRequestWithSuccess:success failed:failed];
        }
        else
        {
                [self _startEachRequestWithSuccess:success failed:failed];
        }
}
- (void)_startOrderRequestWithSuccess:(GroupRequestSuccessBlock)success failed:(GroupRequestFailedBlock)failed
{
        dispatch_async(YYDispatchQueueGetForQOS(NSQualityOfServiceBackground), ^{
                
                __block NSError *requestError = nil;
                
                dispatch_semaphore_t sema = dispatch_semaphore_create(1);
                
                [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                        
                        if (requestError != nil)
                        {
                                *stop = YES;
                                dispatch_semaphore_signal(sema);
                                return ;
                        }
                        
                        if ([obj isKindOfClass:[BaseRequest class]])
                        {
                                [(BaseRequest *)obj groupInterSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof id  _Nonnull data) {
                                        dispatch_semaphore_signal(sema);
                                } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                                        if (!request.groupIgnoreError)
                                        {
                                                requestError = error;
                                        }
                                        dispatch_semaphore_signal(sema);
                                }];
                        }
                        else if ([obj isKindOfClass:[NSArray class]])
                        {
                                [(NSArray *)obj startRequestWithSuccess:^(NSArray *requests) {
                                         dispatch_semaphore_signal(sema);
                                } failed:^(NSArray *requests, NSError *error) {
                                        dispatch_semaphore_signal(sema);
                                }];
                        }
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                        if (requestError)
                        {
                                failed(self,requestError);
                        }
                        else
                        {
                                success(self);
                        }
                });
        });
}

- (void)_startEachRequestWithSuccess:(GroupRequestSuccessBlock)success failed:(GroupRequestFailedBlock)failed
{
        __block NSError *requestError = nil;
        NSMutableArray <BaseRequest *>*requestArray = [self getRealRequestFromSelfSync:NO];
        
        dispatch_group_t group = dispatch_group_create();
        
        [requestArray enumerateObjectsUsingBlock:^(BaseRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                dispatch_group_enter(group);
                [obj groupInterSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof id  _Nonnull data) {
                        dispatch_group_leave(group);
                } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                        if (!request.groupIgnoreError) {
                                requestError = error;
                                *stop = YES;
                        }
                        dispatch_group_leave(group);
                }];
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                
                if (requestError)
                {
                        failed(self,requestError);
                }
                else
                {
                        success(self);
                }
        });
}

- (NSMutableArray <BaseRequest *>*)getRealRequestFromSelfSync:(BOOL)sync
{
        NSMutableArray <BaseRequest *>*requestArray = [NSMutableArray arrayWithCapacity:self.count];
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[BaseRequest class]])
                {
                        if (!sync)
                        {
                                [(BaseRequest  *)obj setCallBackQueue:YYDispatchQueueGetForQOS(NSQualityOfServiceBackground)];
                        }
                        [requestArray addObject:obj];
                }
                else if ([obj isKindOfClass:[NSArray class]])
                {
                        [requestArray addObjectsFromArray:[(NSArray *)obj getRealRequestFromSelfSync:sync]];
                }
        }];
        return requestArray;
}
@end
