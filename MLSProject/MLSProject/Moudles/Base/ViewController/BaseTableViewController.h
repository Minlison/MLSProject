//
//  BaseTableViewController.h
//  MinLison
//
//  Created by MinLison on 2017/10/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableControllerViewProtocol.h"
#import "BaseTableViewDataSource.h"
#import "BaseTableViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN
/// MARK: - Copy from QMUIKit
/**
 *  配合属性 `tableViewInitialContentInset` 使用，标志 `tableViewInitialContentInset` 是否有被修改过
 *  @see tableViewInitialContentInset
 */
extern const UIEdgeInsets BaseCommonTableViewControllerInitialContentInsetNotSet;

/**
 *  可作为项目内所有 `UITableViewController` 的基类，注意是继承自 `BaseCommonViewController` 而不是 `UITableViewController`。
 *
 *  一般通过 `initWithStyle:` 方法初始化，对于要生成 `UITableViewStylePlain` 类型的列表，推荐使用 `init:` 方法。
 *
 *  提供的功能包括：
 *
 *  1. 集成 `BaseSearchController`，可通过属性 `shouldShowSearchBar` 来快速为列表生成一个 searchBar 及 searchController，具体请查看 BaseCommonTableViewController (Search)。
 *
 *  2. 通过属性 `tableViewInitialContentInset` 和 `tableViewInitialScrollIndicatorInsets` 来提供对界面初始状态下的列表 `contentInset`、`contentOffset` 的调整能力，一般在系统的 `automaticallyAdjustsScrollViewInsets` 属性无法满足需求时使用。
 *
 *  @note emptyView 会从 tableHeaderView 的下方开始布局到 tableView 最底部，因此它会遮挡 tableHeaderView 之外的部分（比如 tableFooterView 和 cells ），你可以重写 layoutEmptyView 来改变这个布局方式
 *
 *  @see BaseSearchController
 */
@interface BaseTableViewController <__covariant ViewType : UIView <BaseTableControllerViewProtocol> * >  : BaseViewController <ViewType> <NIMutableTableViewModelDelegate, QMUITableViewDelegate>

- (instancetype)initWithStyle:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

/**
 *  初始化时调用的方法，会在两个 NS_DESIGNATED_INITIALIZER 方法中被调用，所以子类如果需要同时支持两个 NS_DESIGNATED_INITIALIZER 方法，则建议把初始化时要做的事情放到这个方法里。否则仅需重写要支持的那个 NS_DESIGNATED_INITIALIZER 方法即可。
 */
- (void)didInitializedWithStyle:(UITableViewStyle)style NS_REQUIRES_SUPER;

/**
 主动调用，配置 Nimbus
 */
- (void)configNimbus NS_REQUIRES_SUPER; 

/**
 NITableViewModel
 */
@property(nonatomic, strong, nullable) NIMutableTableViewModel *tableViewModel;

/**
 NITableAction
 */
@property(nonatomic, strong, nullable) NITableViewActions *tableViewActions;

/**
 tableView 代理对象，用来实现一些方法，去掉 group header 和 group footer
 默认 receiver 是控制器本身
 */
@property(nonatomic, strong, readonly) BaseTableViewDelegate *privateDelegate;
/**
 cell 工程管理
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 return [self.cellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.model];
 }
 */
@property(nonatomic, strong) NICellFactory *cellFactory;

/// 获取当前的 `UITableViewStyle`
@property(nonatomic, assign, readonly) UITableViewStyle style;

/// 获取当前的 tableView
@property(nonatomic, strong) BaseTableView *tableView;

/**
 *  列表使用自定义的contentInset，不使用系统默认计算的，默认为QMUICommonTableViewControllerInitialContentInsetNotSet。<br/>
 *  当更改了这个值后，会把self.automaticallyAdjustsScrollViewInsets = NO
 */
@property(nonatomic, assign) UIEdgeInsets tableViewInitialContentInset;

/**
 *  是否需要让scrollIndicatorInsets与tableView.contentInsets区分开来，如果不设置，则与tableView.contentInset保持一致。
 *
 *  只有当更改了tableViewInitialContentInset后，这个属性才会生效。
 */
@property(nonatomic, assign) UIEdgeInsets tableViewInitialScrollIndicatorInsets;

- (void)hideTableHeaderViewInitialIfCanWithAnimated:(BOOL)animated force:(BOOL)force;
@end

@interface BaseTableViewController (BaseSubclassingHooks)

/**
 *  初始化tableView，在initSubViews的时候被自动调用。
 *
 *  一般情况下，有关tableView的设置属性的代码都应该写在这里。
 */
- (void)initTableView;

/**
 *  是否需要在第一次进入界面时将tableHeaderView隐藏（通过调整self.tableView.contentOffset实现）
 *
 *  默认为NO
 *
 *  @see QMUITableViewDelegate
 */
- (BOOL)shouldHideTableHeaderViewInitial;



@end

NS_ASSUME_NONNULL_END
