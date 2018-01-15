//
//  MLSIDNumberValidator.m
//  MLSProject
//
//  Created by MinLison on 2017/12/14.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSIDNumberValidator.h"
#import "MLSIDNumberCondation.h"
@implementation MLSIDNumberValidator
- (id)init
{
        self = [super init];
        if (self)
        {
                [self addCondition:[[MLSIDNumberCondation alloc] init]];
        }
        
        return self;
}
@end
