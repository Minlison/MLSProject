//
//  BaseModel.h
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 用户校验该模型本身是否可用
 */
@protocol ModelValid <NSObject>

/**
 是否有效
 
 @return 是否有效
 */
- (BOOL)isValid;

/**
 错误信息
 */
- (nullable NSError *)validError;

@end

@interface BaseModel : NSObject <YYModel, ModelValid, NSCoding>

@end
