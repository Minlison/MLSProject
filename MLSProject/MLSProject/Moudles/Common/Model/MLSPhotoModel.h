//
//  MLSPhotoModel.h
//  ChengziZdd
//
//  Created by MinLison on 2017/9/11.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import "BaseModel.h"
// Not use
@interface MLSPhotoModel : BaseModel

/**
 图片地址
 */
@property(nonatomic, copy) NSString *imgUrl;

/**
 描述文字
 */
@property(nonatomic, copy) NSString *subTitle;

/**
 快速创建图片模型

 @param img 图片
 @param title 文字描述
 @return 图片模型
 */
+ (instancetype)photoWithImg:(NSString *)img title:(NSString *)title;
@end
