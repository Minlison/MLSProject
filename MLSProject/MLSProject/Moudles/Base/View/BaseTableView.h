//
//  BaseTableView.h
//  MinLison
//
//  Created by MinLison on 2017/10/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "QMUITableView.h"

@interface BaseTableView : QMUITableView

/**
 是否自动调整 header 动画效果
 */
@property(nonatomic, assign) BOOL enableAutoAdjustHeader;

/**
 缩放 header 的背景视图
 默认是与 tableViewHeader bounds 相等的 view
 如果设置不为空 enableAutoAdjustHeader 自动设置成 YES，如果为空 enableAutoAdjustHeader 设置成 NO
 */
@property(nonatomic, strong) UIView *autoAdjustView;
@end
