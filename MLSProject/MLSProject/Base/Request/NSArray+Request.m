//
//  NSArray+Request.m
//  MLSProject
//
//  Created by MinLison on 2017/10/09.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "NSArray+Request.h"
#import "BaseRequest.h"

@interface BaseRequest (Prv)
- (void)groupInterSuccess:(RequestSuccessBlock)success failed:(RequestFailedBlock)failed;
@end

@implementation NSArray (Request)

@extSynthesizeAssociation(NSArray, requestError);

- (void)startRequestWithSuccess:(GroupRequestSuccessBlock)success failed:(GroupRequestFailedBlock)failed
{
        NSMutableArray <BaseRequest *>*requestArray = [NSMutableArray arrayWithCapacity:self.count];
        __block NSError *requestError = nil;
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[BaseRequest class]]) {
                        [requestArray addObject:obj];
                }
        }];
        
        dispatch_group_t group = dispatch_group_create();
        
        [requestArray enumerateObjectsUsingBlock:^(BaseRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                dispatch_group_enter(group);
                [obj groupInterSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof id  _Nonnull data) {
                        dispatch_group_leave(group);
                } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                        requestError = error;
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
@end
