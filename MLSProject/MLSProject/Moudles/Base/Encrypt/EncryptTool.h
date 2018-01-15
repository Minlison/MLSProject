//
//  EncryptTool.h
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EncryptProtocol.h"

/**
 加密解密工具
 */
@interface EncryptTool : NSObject <EncryptProtocol>

/**
 单例

 @return 单例
 */
+ (instancetype)sharedInstance;
@end
