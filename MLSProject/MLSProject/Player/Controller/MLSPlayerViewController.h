//
//  MLSPlayerViewController.h
//  MLSProject
//
//  Created by MinLison on 2017/9/12.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseViewController.h"
#import "MLSPlayerView.h"
#import "MLSPlayerViewModel.h"
#import "MLSPlayerModel.h"

@interface MLSPlayerViewController<__covariant ViewType : UIView <BaseViewProtocol> * > : BaseViewController <MLSPlayerView *>

/**
 连续视频播放,视频模型管理ViewModel
 */
@property(nonatomic, strong, readonly) MLSPlayerViewModel <MLSPlayerModel *>* viewModel;

/**
 是否允许蜂窝网络
 */
@property(nonatomic, assign) BOOL allowCellerNetwork;

/**
 单个视频播放

 @param model 视频模型
 @return  MLSPlayerViewController
 */
+ (instancetype)playerViewControllerWithModel:(MLSPlayerModel *)model;

/**
 连续视频播放

 @param viewModel
 @return MLSPlayerViewController
 */
+ (instancetype)playerViewControllerWithViewModel:(MLSPlayerViewModel <MLSPlayerModel *>*)viewModel;

@end
