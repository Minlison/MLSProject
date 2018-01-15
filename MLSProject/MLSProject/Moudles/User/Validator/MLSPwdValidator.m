//
//  MLSPwdValidator.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSPwdValidator.h"
#import "MLSPwdCondition.h"
@implementation MLSPwdValidator
- (id)init
{
        self = [super init];
        if (self)
        {
                [self addCondition:[MLSPwdCondition condition]];
                
                US2ConditionRange *rangeCondition   = [[US2ConditionRange alloc] init];
                rangeCondition.range                = NSMakeRange(1, 6);
                [self addCondition:rangeCondition];
        }
        
        return self;
}
@end
