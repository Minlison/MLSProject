//
//  BaseCollectionControllerView.m
//  MLSProject
//
//  Created by MinLison on 2017/12/1.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseCollectionControllerView.h"

@interface BaseCollectionControllerView ()
@property(nonatomic, strong) BaseCollectionView *collectionView;
@end

@implementation BaseCollectionControllerView
- (void)setCollectionView:(__kindof BaseCollectionView *)collectionView
{
        _collectionView = collectionView;
}
- (void)setupCollectionView
{
        BOOL showComment = [self.controller alwaysShowCommentView];
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                if (@available(iOS 11.0,*))
                {
                        if (showComment)
                        {
                                make.bottom.equalTo(self.controller.commentToolBar.mas_safeAreaLayoutGuideTop);
                        }
                        else
                        {
                                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
                        }
                        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
                        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
                        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
                }
                else
                {
                        if (showComment)
                        {
                                make.bottom.equalTo(self.controller.commentToolBar.mas_top);
                        }
                        else
                        {
                                make.bottom.equalTo(self.controller.mas_bottomLayoutGuideTop);
                        }
                        make.top.equalTo(self.controller.mas_topLayoutGuideBottom);
                        make.left.right.equalTo(self);
                }
        }];
}
- (void)setupView
{
        [super setupView];
        [self addSubview:self.collectionView];
        [self setupCollectionView];
}

- (void)setCollectionViewModel:(NIMutableCollectionViewModel *)collectionViewModel
{
        _collectionViewModel = collectionViewModel;
        
        self.collectionView.dataSource = collectionViewModel;
}
- (void)setCollectionViewActions:(NICollectionViewActions *)collectionViewActions
{
        _collectionViewActions = collectionViewActions;
        self.collectionView.delegate = collectionViewActions;
}

@end
