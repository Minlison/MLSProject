//
//  MLSPlayerModel.h
//  MLSProject
//
//  Created by MinLison on 2017/9/12.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"
NS_ASSUME_NONNULL_BEGIN
@class MLSPlayerModel;

/**
 播放完成回调

 @param model 视频 Model
 */
typedef void (^MLSPlayeCallBackBlock)(MLSPlayerModel *model);


/**
 重新获取播放地址回调 block

 @param url 获取到的地址
 */
typedef void (^MLSUrlBlock)(NSString * _Nullable url);

/**
 重新获取播放地址

 @param model 视频模型
 @param urlBlock 回调
 */
typedef void (^MLSPlayeRegetPlayUrlCallBackBlock)(MLSPlayerModel *model, MLSUrlBlock urlBlock);

@interface MLSPlayerModel : BaseModel

/**
 视频名
 */
@property(nonatomic, copy) NSString *name;

/**
 视频大小, 字节
 */
@property(nonatomic, copy) NSString *size;

/**
 视频连接
 */
@property(nonatomic, copy) NSString *videoUrl;

/**
 当前播放时长
 */
@property(nonatomic, assign) NSUInteger current;

/**
 总时长
 */
@property(nonatomic, assign) NSUInteger duration;

/**
 重试次数
 */
@property(nonatomic, assign) NSUInteger retryCount;

/**
 错误信息
 */
@property(nonatomic, strong, nullable) NSError *error;

/**
 附加参数, 只会回传和强持有, 不会进行任何操作
 */
@property(nonatomic, strong) id opaqueData;

/**
 播放完成回调
 */
@property(nonatomic, copy, nullable) MLSPlayeCallBackBlock playEndCallBack;

/**
 重新获取播放地址
 */
@property(nonatomic, copy) MLSPlayeRegetPlayUrlCallBackBlock regetUrlCallBack;


@end
NS_ASSUME_NONNULL_END
