//
//  NSDictionary+Sign.h
//  MinLison
//
//  Created by MinLison on 2017/9/29.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Sign)
/**
 方法版本号
 */
@property(nonatomic, copy, nullable, readonly) NSString *versionValue;

/**
 方法编号
 */
@property(nonatomic, copy, nullable, readonly) NSString *methodValue;
@end
