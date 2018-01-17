//
//  MLSPhoneValidator.m
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSPhoneValidator.h"
#import "MLSPhoneCondition.h"
@implementation MLSPhoneValidator
- (id)init
{
        self = [super init];
        if (self)
        {
                [self addCondition:[[MLSPhoneCondition alloc] init]];
                
                US2ConditionRange *rangeCondition   = [[US2ConditionRange alloc] init];
                rangeCondition.range                = NSMakeRange(1, 20);
                [self addCondition:rangeCondition];
        }
        
        return self;
}
@end
