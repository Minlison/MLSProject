//
//  MLSUpdateView.h
//  MinLison
//
//  Created by MinLison on 2017/10/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseControllerView.h"
#import "MLSUpdateModel.h"
#import "MLSUpdateEnum.h"

@interface MLSUpdateView : BaseControllerView

/**
 数据
 */
@property(nonatomic, strong) MLSUpdateModel *updateModel;


/**
 事件回调

 @param actionBlock 事件
 */
- (void)setActionBlock:(WGUpdateActionBlock)actionBlock;
@end
