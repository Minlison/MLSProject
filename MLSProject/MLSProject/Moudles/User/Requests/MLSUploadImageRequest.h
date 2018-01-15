//
//  MLSUploadImageRequest.h
//  MinLison
//
//  Created by MinLison on 2017/11/5.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseRequest.h"
#import "MLSUploadImgModel.h"
@interface MLSUploadImageRequest : BaseRequest <MLSUploadImgModel *>

/**
 初始化

 @param imgFilePath 图片路径
 @return  request
 */
- (instancetype)initWithImgFileUrl:(NSURL *)imgFileUrl;
@end
