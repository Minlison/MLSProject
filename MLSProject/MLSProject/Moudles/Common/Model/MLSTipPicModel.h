//
//  MLSTipPicModel.h
//  MinLison
//
//  Created by minlison on 2017/9/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"

@interface MLSTipPicModel : BaseModel
/**
 图片描述
 */
@property (strong, nonatomic) NSString *desc;
/**
 图片链接
 */
@property (strong, nonatomic) NSString *img;
@end
