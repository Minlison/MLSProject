//
//  MLSPhotoBrowserViewController.h
//  MinLison
//
//  Created by MinLison on 2017/9/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BasePhotoPreviewController.h"
#import "MLSPhotoBrowserView.h"

// Not use
@interface MLSPhotoBrowserViewController : BasePhotoPreviewController <MLSPhotoBrowserView *>

/**
 快速创建图片浏览器

 @param picID 图片数组获取 id
 @return  图片浏览器
 */
+ (instancetype)photoBrowserViewControllerWithPicID:(NSString *)picID;

/**
 单张图片浏览器

 @param imgUrl 图片地址
 @return 图片浏览器
 */
+ (instancetype)photoBrowserViewControllerWithImageUrl:(NSString *)imgUrl;

@end
