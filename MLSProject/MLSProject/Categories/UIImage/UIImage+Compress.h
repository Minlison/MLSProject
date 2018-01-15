//
//  UIImage+Compress.h
//  MinLison
//
//  Created by MinLison on 2017/11/21.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)
/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

/**
 *  压缩图片到指定尺寸大小
 *
 *  @param image 原始图片
 *  @param size  目标大小
 *
 *  @return 生成图片
 */
- (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

/**
 *  压缩图片到指定文件大小
 *
 *  @param imgFile 目标图片路径
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
- (UIImage *)compressImageFile:(NSURL *)imgFile toMaxDataSizeKBytes:(CGFloat)size;
@end
