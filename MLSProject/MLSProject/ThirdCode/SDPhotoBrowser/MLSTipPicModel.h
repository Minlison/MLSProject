//
//  MLSTipPicModel.h
//  MLSProject
//
//  Created by MinLison on 2017/10/9.
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
