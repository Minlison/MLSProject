//
//  MLSGetCountryCodeModel.h
//  MinLison
//
//  Created by MinLison on 2017/11/5.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSPlistModel.h"

@interface MLSGetCountryCodeModel : MLSPlistModel <NICellObject>

/**
 地区编码
 */
@property(nonatomic, copy) NSString *country_code;


/**
 默认的地区编码

 @return 地区编码数组
 */
+ (NSArray <MLSGetCountryCodeModel *>*)defaultCountryCodes;
@end
