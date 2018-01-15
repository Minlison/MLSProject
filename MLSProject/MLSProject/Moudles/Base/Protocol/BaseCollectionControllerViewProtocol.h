//
//  BaseCollectionControllerViewProtocol.h
//  MLSProject
//
//  Created by MinLison on 2017/12/1.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#ifndef BaseCollectionControllerViewProtocol_h
#define BaseCollectionControllerViewProtocol_h
#import "BaseControllerViewProtocol.h"
#import "BaseCollectionView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol BaseCollectionControllerViewProtocol <BaseControllerViewProtocol>


/**
 设置 collectionView 视图
 
 @param collectionView
 */
- (void)setCollectionView:(__kindof BaseCollectionView *)collectionView;


/**
 tableView
 */
@property(nonatomic, strong, readonly) __kindof BaseCollectionView *collectionView;

/**
 布局 tableView
 */
- (void)setupCollectionView;

@optional
/**
 NITableViewModel
 */
@property(nonatomic, strong, nullable) NIMutableCollectionViewModel *collectionViewModel;

/**
 NITableAction
 */
@property(nonatomic, strong, nullable) NICollectionViewActions *collectionViewActions;
@end

NS_ASSUME_NONNULL_END
#endif /* BaseCollectionControllerViewProtocol_h */
