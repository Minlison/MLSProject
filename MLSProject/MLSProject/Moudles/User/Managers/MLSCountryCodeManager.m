//
//  MLSCountryCodeManager.m
//  MinLison
//
//  Created by MinLison on 2017/11/5.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSCountryCodeManager.h"
#import "MLSGetCountryCodeCell.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface WGCountryCodeModel ()

@end
@implementation WGCountryCodeModel
- (Class)cellClass
{
        return [MLSGetCountryCodeCell class];
}
- (NSString *)country_name
{
        if (!_country_name) {
                _country_name = [[NSLocale localeWithLocaleIdentifier:@"en_US"] displayNameForKey:NSLocaleCountryCode value:self.country_code];
                if (!_country_name) {
                        NSString *languageCode = [[NSLocale currentLocale] languageCode];
                        if ([languageCode hasPrefix:@"zh"]) {
                                _country_name = self.country_cn;
                        } else {
                                _country_name = self.country_en;
                        }
                }
        }
        return _country_name;
}
- (UIImage *)getCountryImage
{
        return [MLSCountryCodeManager imageForCountryCode:self.country_code];
}
@end

@implementation MLSCountryCodeManager
+ (NSDictionary<NSString *,NSArray<WGCountryCodeModel *> *> *)getDefaultCountryCodes
{
        NSString *languageCode = [[NSLocale currentLocale] languageCode];
        if ([languageCode hasPrefix:@"zh"]) {
                /*
                 zh        中文
                 zh-CN        中文(简体)
                 zh-HK        中文(香港)
                 zh-MO        中文(澳门)
                 zh-SG        中文(新加坡)
                 zh-TW        中文(繁体)
                 */
                return [self chineseSortWithDictionaryArray:[self countryInfos]];;
        }
        return [self englishSortWithDictionaryArray:[self countryInfos]];
}
+ (NSBundle *)resourceBundle{
        return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"WGPhoneCountry" ofType:@"bundle"]];
}

+ (NSData *)jsonDataForPath:(NSString *)path {
        return [[[NSString alloc] initWithContentsOfFile:[[self resourceBundle] pathForResource:path ofType:@"json"]
                                                encoding:NSUTF8StringEncoding
                                                   error:NULL]
                dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSArray *)countryInfos {
        return [NSJSONSerialization JSONObjectWithData:[self jsonDataForPath:@"phone_country_code"]
                                               options:kNilOptions
                                                 error:nil];
}

+ (NSDictionary *)flagIndices {
        return [NSJSONSerialization JSONObjectWithData:[self jsonDataForPath:@"flag_indices"]
                                               options:kNilOptions
                                                 error:nil];
}
+ (NSDictionary*)englishSortWithDictionaryArray:(NSArray *)dictionaryArray {
        NSMutableArray * sourceArray = [dictionaryArray mutableCopy];
        [sourceArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [[obj1 objectForKey:@"country_en"] compare:[obj2 objectForKey:@"country_en"]];
        }];
        
        NSMutableDictionary * resultDic = [NSMutableDictionary dictionary];
        for (unichar firstChar = 'A'; firstChar <= 'Z'; firstChar ++) {
                [resultDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%C",firstChar]];
        }
        for (NSDictionary * dic in sourceArray) {
                WGCountryCodeModel *model = [WGCountryCodeModel modelWithJSON:dic];
                [(NSMutableArray *)resultDic[[dic[@"country_en"] substringToIndex:1]] addObject:model];
        }
        for (NSString * key in [resultDic allKeys]) {
                if ([resultDic[key] count] == 0) {
                        [resultDic removeObjectForKey:key];
                }
        }
        return resultDic;
}

+ (NSDictionary*)chineseSortWithDictionaryArray:(NSArray *)dictionaryArray {
        if (dictionaryArray == nil) {
                return nil;
        }
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (int i = 0 ; i < [dictionaryArray count] ; i++) {
                if (![[dictionaryArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                        return nil;
                }
                NSDictionary *tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:[dictionaryArray objectAtIndex:i], @"info", [self chineseStringTransformPinyin:[[dictionaryArray objectAtIndex:i] objectForKey:@"country_cn"]], @"pinyin", nil];
                [tempArray addObject:tempDic];
        }
        // 排序
        [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [[obj1 objectForKey:@"pinyin"] compare:[obj2 objectForKey:@"pinyin"]];
        }];
        
        NSMutableDictionary * resultDic = [NSMutableDictionary dictionary];
        for (unichar firstChar = 'A'; firstChar <= 'Z'; firstChar ++) {
                [resultDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%C",firstChar]];
        }
        for (NSDictionary * dic in tempArray) {
                WGCountryCodeModel *model = [WGCountryCodeModel modelWithJSON:dic[@"info"]];
                [(NSMutableArray *)resultDic[[dic[@"pinyin"] substringToIndex:1]] addObject:model];
        }
        for (NSString * key in [resultDic allKeys]) {
                if ([resultDic[key] count] == 0) {
                        [resultDic removeObjectForKey:key];
                }
        }
        return resultDic;
}

+ (NSString*)chineseStringTransformPinyin: (NSString*)chineseString {
        if (chineseString == nil) {
                return nil;
        }
        // 拼音字段
        NSMutableString *tempNamePinyin = [chineseString mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)tempNamePinyin, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)tempNamePinyin, NULL, kCFStringTransformStripDiacritics, NO);
        return tempNamePinyin.uppercaseString;
}
+ (UIImage *)imageForCountryCode:(NSString *)code{
        NSNumber * y = [self flagIndices][code];
        if (!y) {
                y = @0;
        }
        CGImageRef cgImage = CGImageCreateWithImageInRect([[UIImage imageWithContentsOfFile:[[self resourceBundle] pathForResource:@"flags" ofType:@"png"]] CGImage], CGRectMake(0, y.integerValue * 2, 32, 32));
        UIImage * result = [UIImage imageWithCGImage:cgImage scale:2.0 orientation:UIImageOrientationUp];
        CGImageRelease(cgImage);
        return result;
}

+ (id)infoFromSimCardAndiOSSettings{
        
        NSArray * array = [self countryInfos];
        
        NSString * carrierIsoCountryCode = [[[[[CTTelephonyNetworkInfo alloc] init] subscriberCellularProvider] isoCountryCode] uppercaseString];
        
        id(^getCountryDic)(NSString*) = ^(NSString * code){
                id result = nil;
                if (code) {
                        for (NSDictionary * dic in array) {
                                if ([dic[@"country_code"] isEqualToString:code]) {
                                        result = dic;
                                        break;
                                }
                        }
                }
                return result;
        };
        
        id info = getCountryDic(carrierIsoCountryCode);
        if (!info) {
                info = getCountryDic([[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode] uppercaseString]);
        }
        return info;
}



+ (id)infoForPhoneCode:(NSInteger)phoneCode{
        NSArray * array = [self countryInfos];
        
        id result = nil;
        for (NSDictionary * dic in array) {
                if (phoneCode == [dic[@"phone_code"] integerValue]) {
                        result = dic;
                        break;
                }
        }
        return result;
}
@end
