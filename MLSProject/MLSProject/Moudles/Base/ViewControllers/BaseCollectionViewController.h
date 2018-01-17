//
//  BaseCollectionViewController.h
//  MLSProject
//
//  Created by MinLison on 2017/12/1.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseCollectionControllerViewProtocol.h"
NS_ASSUME_NONNULL_BEGIN

extern const UIEdgeInsets BaseCommonCollectionViewControllerInitialContentInsetNotSet;

@interface BaseCollectionViewController <__covariant ViewType : UIView <BaseCollectionControllerViewProtocol> * >  : BaseViewController <ViewType> <NICollectionViewModelDelegate,NICollectionViewDelegate>

/**
 布局信息
 可以重置
 */
@property (strong, nonatomic) UICollectionViewLayout *layout;

/**
 初始化控制器

 @param layout 布局信息
 @return 控制器
 */
- (instancetype)initWithCollectionViewLayout:(nullable UICollectionViewLayout *)layout;

/**
 创建flowLayout

 @return layout布局
 */
- (UICollectionViewFlowLayout *)createFlowLayout;
/**
 初始化成功

 @param layout 布局
 */
- (void)didInitializedWithLayout:(UICollectionViewLayout *)layout;

/**
 配置 nimbus
 */
- (void)configNimbus NS_REQUIRES_SUPER;


/**
 NIMutableCollectionViewModel
 */
@property(nonatomic, strong, nullable) NIMutableCollectionViewModel *collectionViewModel;

/**
 NICollectionViewActions
 */
@property(nonatomic, strong, nullable) NICollectionViewActions *collectionViewActions;

/**
 cell 工程管理
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 return [self.cellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.model];
 }
 */
@property(nonatomic, strong) NICollectionViewCellFactory *cellFactory;

/**
 *  列表使用自定义的contentInset，不使用系统默认计算的，默认
 *  当更改了这个值后，会把self.automaticallyAdjustsScrollViewInsets = NO
 */
@property(nonatomic, assign) UIEdgeInsets collectionViewInitialContentInset;

/**
 获取当前的 collectionView
 */
@property(nonatomic, strong) BaseCollectionView *collectionView;

/**
 *  是否需要让scrollIndicatorInsets与tableView.contentInsets区分开来，如果不设置，则与tableView.contentInset保持一致。
 *
 *  只有当更改了tableViewInitialContentInset后，这个属性才会生效。
 */
@property(nonatomic, assign) UIEdgeInsets collectionViewInitialScrollIndicatorInsets;

@end

@interface BaseCollectionViewController (BaseSubclassingHooks)

/**
 *  初始化tableView，在initSubViews的时候被自动调用。
 *
 *  一般情况下，有关tableView的设置属性的代码都应该写在这里。
 */
- (void)initCollectionView;

@end
NS_ASSUME_NONNULL_END
