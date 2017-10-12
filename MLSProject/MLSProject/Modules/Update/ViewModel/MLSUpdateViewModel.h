//
//  MLSUpdateViewModel.h
//  MLSProject
//
//  Created by MinLison on 2017/10/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseViewModel.h"
#import "MLSUpdateModel.h"
@interface MLSUpdateViewModel : BaseViewModel

/**
 数据
 */
@property(nonatomic, strong) MLSUpdateModel *model;

/**
 是否可以显示
 */
@property(nonatomic, assign, readonly) BOOL canShow;

/**
 稍后显示
 */
- (void)latter;

/**
 立即更新
 */
- (void)updateNow;

@end
