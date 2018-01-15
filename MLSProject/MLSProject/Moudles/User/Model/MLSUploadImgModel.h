//
//  MLSUploadImgModel.h
//  MinLison
//
//  Created by MinLison on 2017/11/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"

@interface MLSUploadImgModel : BaseModel

/**
 图片id
 */
@property(nonatomic, copy) NSString *id;

/**
 图片地址
 */
@property(nonatomic, copy) NSString *url;
@end
