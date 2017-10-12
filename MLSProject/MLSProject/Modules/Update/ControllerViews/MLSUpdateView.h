//
//  MLSUpdateView.h
//  MLSProject
//
//  Created by MinLison on 2017/10/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseView.h"
#import "MLSUpdateModel.h"
#import "MLSUpdateEnum.h"

@interface MLSUpdateView : BaseView

/**
 数据
 */
@property(nonatomic, strong) MLSUpdateModel *updateModel;


/**
 事件回调

 @param actionBlock 事件
 */
- (void)setActionBlock:(MLSUpdateActionBlock)actionBlock;
@end
