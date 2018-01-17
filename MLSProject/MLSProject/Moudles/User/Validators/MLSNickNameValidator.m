//
//  MLSNickNameValidator.m
//  MinLison
//
//  Created by MinLison on 2017/11/5.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSNickNameValidator.h"
#import "MLSNickNameCondition.h"
@implementation MLSNickNameValidator
- (id)init
{
        self = [super init];
        if (self)
        {
                [self addCondition:[[MLSNickNameCondition alloc] init]];
                
                US2ConditionRange *rangeCondition   = [[US2ConditionRange alloc] init];
                rangeCondition.range                = NSMakeRange(1, 20);
                [self addCondition:rangeCondition];
        }
        
        return self;
}
@end
