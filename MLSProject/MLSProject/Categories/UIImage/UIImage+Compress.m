//
//  UIImage+Compress.m
//  MinLison
//
//  Created by MinLison on 2017/11/21.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)
- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size
{
        NSData * data = UIImageJPEGRepresentation(image, 1.0);
        CGFloat dataKBytes = data.length/1000.0;
        CGFloat maxQuality = 0.9f;
        CGFloat lastData = dataKBytes;
        while (dataKBytes > size && maxQuality > 0.01f)
        {
                maxQuality = maxQuality - 0.01f;
                data = UIImageJPEGRepresentation(image, maxQuality);
                dataKBytes = data.length / 1000.0;
                if (lastData == dataKBytes)
                {
                        break;
                }
                else
                {
                        lastData = dataKBytes;
                }
        }
        return data;
}

- (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size
{
        UIImage * resultImage = image;
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(00, 0, size.width, size.height)];
        UIGraphicsEndImageContext();
        return image;
}
- (UIImage *)compressImageFile:(NSURL *)imgFile toMaxDataSizeKBytes:(CGFloat)size
{
        return [self compressOriginalImage:[UIImage imageWithContentsOfFile:imgFile.absoluteString] toMaxDataSizeKBytes:size];
}
@end
