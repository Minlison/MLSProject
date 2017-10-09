//
//  RMUUid.h
//  WxbClient
//
//  Created by Sally Sun on 13-7-10.
//  Copyright (c) 2013年 Run Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMUUid : NSObject

/** 永远不要修改这个方法，涉及到支付 */
+ ( NSString *)getUUid;

+ ( NSString *)getMD5UUid;

@end
