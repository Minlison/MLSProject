//
//  RMUUid.h
//  WxbClient
//
//  Created by Sally Sun on 13-7-10.
//  Copyright (c) 2013年 Run Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMUUid : NSObject

/**
 应用唯一标识符 UTDID MD5
 长度不会更改

 @return 标识符
 */
+ ( NSString *)getUUid;

/**
 UTDID

 @return  唯一标识符
 */
+ ( NSString *)getUTDID;

@end
