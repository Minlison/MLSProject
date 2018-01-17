//
//  MLSSMSValidator.m
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSSMSValidator.h"
#import "MLSSMSCondition.h"
@implementation MLSSMSValidator
- (id)init
{
        self = [super init];
        if (self)
        {
                [self addCondition:[MLSSMSCondition condition]];
                
                US2ConditionRange *rangeCondition   = [[US2ConditionRange alloc] init];
                rangeCondition.range                = NSMakeRange(1, 6);
                [self addCondition:rangeCondition];
        }
        
        return self;
}
@end
