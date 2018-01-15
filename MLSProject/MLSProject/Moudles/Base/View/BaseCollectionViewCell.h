//
//  BaseCollectionViewCell.h
//  MLSProject
//
//  Created by MinLison on 2017/12/2.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewCell : UICollectionViewCell

/**
 配置子视图
 */
- (void)setupView NS_REQUIRES_SUPER;

/**
 获取最大值
 会出去collectionView的inset
 flowLayout的 sectionInset

 @return 最大值
 */
+ (CGSize)getMaxSizeInCollectionView:(UICollectionView *)collectionView inSection:(NSInteger)section;

/**
 获取最小行间距

 @param collectionView collectionview
 @param section section
 @return 最小行间距
 */
+ (CGFloat)getMinLineSpacingMarginInCollectionView:(UICollectionView *)collectionView inSection:(NSInteger)section;

/**
 获取最小item间距

 @param collectionView collectionView description
 @param section section description
 @return 最小item间距
 */
+ (CGFloat)getMinItemMarginInCollectionView:(UICollectionView *)collectionView inSection:(NSInteger)section;
@end
