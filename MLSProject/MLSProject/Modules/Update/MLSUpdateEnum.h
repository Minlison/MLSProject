//
//  MLSUpdateEnum.h
//  MLSProject
//
//  Created by MinLison on 2017/10/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef MLSUpdateEnum_h
#define MLSUpdateEnum_h
#import <UIKit/UIKit.h>

/**
 事件类型

 - MLSUpdateActionTypeLater: 稍后升级
 - MLSUpdateActionTypeNow: 现在升级
 */
typedef NS_ENUM(NSInteger, MLSUpdateActionType)
{
        MLSUpdateActionTypeLater,
        MLSUpdateActionTypeNow,
};

typedef void (^MLSUpdateActionBlock)(MLSUpdateActionType type);

/**
  升级类型

 - MLSUpdateTypeNormal: 普通升级
 - MLSUpdateTypeEmergency: 紧急/重要 升级
 */
typedef NS_ENUM(NSInteger, MLSUpdateType)
{
        MLSUpdateTypeNormal = 1,
        MLSUpdateTypeEmergency = 2,
};
#endif /* MLSUpdateEnum_h */
