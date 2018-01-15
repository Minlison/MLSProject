//
//  MLSPlistModel.h
//  MinLison
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"

@interface MLSPlistModel : BaseModel

/**
 图片
 */
@property(nonatomic, copy) NSString *iconName;

/**
 标题
 */
@property(nonatomic, copy) NSString *title;

/**
 跳转控制器的 Class
 */
@property(nonatomic, copy) NSString *nextClassName;

@end

