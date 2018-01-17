//
//  MLSImagePickerViewController.h
//  MinLison
//
//  Created by MinLison on 2017/11/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 成功回调

 @param localImgUrl 图片本地存储路径，当是删除图片的时候，回调图片为空
 @param image 选择的图片，当是删除图片的时候，回调图片为空
 */
typedef void (^MLSImagePickerSuccessBlock)( NSURL * _Nullable localImgUrl, UIImage *_Nullable image);
typedef void (^MLSImagePickerFailedBlock)(NSError *error);

typedef NS_OPTIONS(NSInteger,MLSImagePickerType)
{
        MLSImagePickerTypeTakePhoto = 1 << 0,
        MLSImagePickerTypeChoseImage = 1 << 1,
        MLSImagePickerTypeSearchImage = 1 << 2,
        MLSImagePickerTypeAll = MLSImagePickerTypeTakePhoto | MLSImagePickerTypeChoseImage | MLSImagePickerTypeSearchImage,
};

@interface MLSImagePickerViewController : BaseViewController

/**
 选择图片
 @param type 类型
 @param vc 在哪个控制器里显示，如果为 nil 则自动选择跟控制器
 @param editImage 需要编辑的图片，如果为空，则为选择图片
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)show:(MLSImagePickerType)type inController:(nullable UIViewController *)vc editImage:(nullable UIImage *)editImage success:(MLSImagePickerSuccessBlock)success failed:(MLSImagePickerFailedBlock)failed;
@end

NS_ASSUME_NONNULL_END
