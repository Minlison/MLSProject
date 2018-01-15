//
//  BaseCollectionControllerView.h
//  MLSProject
//
//  Created by MinLison on 2017/12/1.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseControllerView.h"
#import "BaseCollectionControllerViewProtocol.h"
@interface BaseCollectionControllerView : BaseControllerView <BaseCollectionControllerViewProtocol>
/**
 NITableViewModel
 */
@property(nonatomic, strong, nullable) NIMutableCollectionViewModel *collectionViewModel;

/**
 NITableAction
 */
@property(nonatomic, strong, nullable) NICollectionViewActions *collectionViewActions;
@end
