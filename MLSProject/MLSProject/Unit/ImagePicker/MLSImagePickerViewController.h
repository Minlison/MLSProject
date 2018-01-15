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
typedef void (^LNImagePickerSuccessBlock)( NSURL * _Nullable localImgUrl, UIImage *_Nullable image);
typedef void (^LNImagePickerFailedBlock)(NSError *error);

typedef NS_OPTIONS(NSInteger,LNImagePickerType)
{
        LNImagePickerTypeTakePhoto = 1 << 0,
        LNImagePickerTypeChoseImage = 1 << 1,
        LNImagePickerTypeSearchImage = 1 << 2,
        LNImagePickerTypeAll = LNImagePickerTypeTakePhoto | LNImagePickerTypeChoseImage | LNImagePickerTypeSearchImage,
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
+ (void)show:(LNImagePickerType)type inController:(nullable UIViewController *)vc editImage:(nullable UIImage *)editImage success:(LNImagePickerSuccessBlock)success failed:(LNImagePickerFailedBlock)failed;
@end

NS_ASSUME_NONNULL_END
