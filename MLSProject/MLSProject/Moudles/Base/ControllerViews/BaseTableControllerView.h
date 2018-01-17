//
//  BaseTableControllerView.h
//  MinLison
//
//  Created by MinLison on 2017/10/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseControllerView.h"
#import "BaseTableControllerViewProtocol.h"
@interface BaseTableControllerView : BaseControllerView <BaseTableControllerViewProtocol>
/**
 NITableViewModel
 */
@property(nonatomic, strong, nullable) NIMutableTableViewModel *tableViewModel;

/**
 NITableAction
 */
@property(nonatomic, strong, nullable) NITableViewActions *tableViewActions;

@end
