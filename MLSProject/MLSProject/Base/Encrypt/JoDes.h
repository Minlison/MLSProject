//
//  JoDes.h
//  test
//
//  Created by MinLison on 15/9/12.
//  Copyright (c) 2015年 minlison. All rights reserved.
//
/***  JoDes.h ***/

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface JoDes : NSObject

+ (NSString *) encode:(NSString *)str key:(NSString *)key;
+ (NSString *) decode:(NSString *)str key:(NSString *)key;

@end
