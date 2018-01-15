//
//  BaseCollectionViewCell.m
//  MLSProject
//
//  Created by MinLison on 2017/12/2.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
        if (self = [super initWithFrame:frame])
        {
                self.contentView.clipsToBounds = YES;
                self.clipsToBounds = YES;
                self.contentView.backgroundColor = self.backgroundColor ?:[UIColor whiteColor];
//                [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.edges.equalTo(self);
//                }];
                [self setupView];
        }
        return self;
}
+ (CGFloat)getMinLineSpacingMarginInCollectionView:(UICollectionView *)collectionView inSection:(NSInteger)section
{
        UICollectionViewFlowLayout *flowLayout = nil;
        CGFloat minLineSpacing = 0;
        if ([collectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
                if ([collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)])
                {
                        minLineSpacing = [(id <UICollectionViewDelegateFlowLayout>)collectionView.delegate collectionView:collectionView layout:flowLayout minimumLineSpacingForSectionAtIndex:section];
                }
        }
        return minLineSpacing;
}


+ (CGFloat)getMinItemMarginInCollectionView:(UICollectionView *)collectionView inSection:(NSInteger)section
{
        UICollectionViewFlowLayout *flowLayout = nil;
        CGFloat minInterItemSpacing = 0;
        if ([collectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
                if ([collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)])
                {
                        minInterItemSpacing = [(id <UICollectionViewDelegateFlowLayout>)collectionView.delegate collectionView:collectionView layout:flowLayout minimumInteritemSpacingForSectionAtIndex:section];
                }
        }
        return minInterItemSpacing;
}

+ (CGSize)getMaxSizeInCollectionView:(UICollectionView *)collectionView inSection:(NSInteger)section
{
        UICollectionViewFlowLayout *flowLayout = nil;
        UIEdgeInsets sectionInset = UIEdgeInsetsZero;
        if ([collectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
                sectionInset = flowLayout.sectionInset;
                if ([collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
                {
                        sectionInset = [(id <UICollectionViewDelegateFlowLayout>)collectionView.delegate collectionView:collectionView layout:flowLayout insetForSectionAtIndex:section];
                }
        }
        CGFloat height = collectionView.height - collectionView.contentInset.top - collectionView.contentInset.bottom;
        CGFloat width = collectionView.width - collectionView.contentInset.left - collectionView.contentInset.right;
        if (flowLayout) {
                height = height - sectionInset.top - sectionInset.bottom;
                width = width - sectionInset.left - sectionInset.right;
        }
        return CGSizeMake(width-1, height);
        
        
}
- (CGSize)getMaxSizeInCollectionView:(UICollectionView *)collectionView inSection:(NSInteger)section
{
        return [[self class] getMaxSizeInCollectionView:collectionView inSection:section];
}
- (void)setupView
{
        
}
@end
