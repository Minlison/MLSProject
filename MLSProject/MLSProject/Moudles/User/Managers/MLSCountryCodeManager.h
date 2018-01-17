//
//  MLSCountryCodeManager.h
//  MinLison
//
//  Created by MinLison on 2017/11/5.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "country_code" : "TD",
 "country_en" : "Chad",
 "country_cn" : "乍得",
 "phone_code" : 235
 */
@interface WGCountryCodeModel : BaseModel <NICellObject>

/**
 国家编码
 */
@property(nonatomic, copy) NSString *country_code;

/**
 国家英文名称
 */
@property(nonatomic, copy) NSString *country_en;

/**
 国家中文名称
 */
@property(nonatomic, copy) NSString *country_cn;

/**
 国家名称，根据本地语言自动转换
 */
@property(nonatomic, copy) NSString *country_name;

/**
 电话区号
 */
@property(nonatomic, copy) NSString *phone_code;

/**
 获取国旗图片

 @return 国旗
 */
- (UIImage *)getCountryImage;
@end

@interface MLSCountryCodeManager : NSObject

/**
 默认的国家地区编码

 @return 地区编码
 */
+ (NSDictionary <NSString *, NSArray <WGCountryCodeModel *>*>*)getDefaultCountryCodes;

/**
 根据国家编码获取国旗

 @param code 国家代码
 @return 国旗图片
 */
+ (UIImage *)imageForCountryCode:(NSString *)code;
@end
