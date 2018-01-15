//
//  BaseTableControllerViewProtocol.h
//  MinLison
//
//  Created by MinLison on 2017/10/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef BaseTableViewProtocol_h
#define BaseTableViewProtocol_h
#import "BaseControllerViewProtocol.h"
#import "BaseTableView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol BaseTableControllerViewProtocol <BaseControllerViewProtocol>


/**
 设置 tableview 视图

 @param tableView 
 */
- (void)setTableView:(__kindof BaseTableView *)tableView;


/**
 tableView
 */
@property(nonatomic, strong, readonly) __kindof BaseTableView *tableView;

/**
 布局 tableView
 */
- (void)setupTableView;

@optional
/**
 NITableViewModel
 */
@property(nonatomic, strong, nullable) NIMutableTableViewModel *tableViewModel;

/**
 NITableAction
 */
@property(nonatomic, strong, nullable) NITableViewActions *tableViewActions;
@end

NS_ASSUME_NONNULL_END


#endif /* BaseTableViewProtocol_h */
