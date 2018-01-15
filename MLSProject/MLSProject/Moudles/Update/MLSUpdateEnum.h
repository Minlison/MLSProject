//
//  MLSUpdateEnum.h
//  MinLison
//
//  Created by MinLison on 2017/10/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef MLSUpdateEnum_h
#define MLSUpdateEnum_h
#import <UIKit/UIKit.h>

/**
 事件类型

 - WGUpdateActionTypeLater: 稍后升级
 - WGUpdateActionTypeNow: 现在升级
 */
typedef NS_ENUM(NSInteger, WGUpdateActionType)
{
        WGUpdateActionTypeLater,
        WGUpdateActionTypeNow,
};

typedef void (^WGUpdateActionBlock)(WGUpdateActionType type);

/**
  升级类型

 - WGUpdateTypeNormal: 普通升级
 - WGUpdateTypeEmergency: 紧急/重要 升级
 */
typedef NS_ENUM(NSInteger, WGUpdateType)
{
        WGUpdateTypeNormal = 1,
        WGUpdateTypeEmergency = 2,
};
#endif /* MLSUpdateEnum_h */
