//
//  MLSGetCountryCodeModel.m
//  MinLison
//
//  Created by MinLison on 2017/11/5.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSGetCountryCodeModel.h"
#import "MLSGetCountryCodeCell.h"
@implementation MLSGetCountryCodeModel
- (Class)cellClass
{
        return [MLSGetCountryCodeCell class];
}
+ (NSArray <MLSGetCountryCodeModel *>*)defaultCountryCodes
{
        NSString *contentPath = [[NSBundle mainBundle] pathForResource:@"WGCountyCode" ofType:@"plist"];
        if (NULLString(contentPath)) {
                return nil;
        }
        NSArray *content = [[NSArray alloc] initWithContentsOfFile:contentPath];
        return [NSArray modelArrayWithClass:[MLSGetCountryCodeModel class] json:content];
}
@end
