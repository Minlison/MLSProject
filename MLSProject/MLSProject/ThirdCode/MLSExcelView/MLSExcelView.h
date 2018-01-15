//
//  MLSExcelView.h
//  MLSExcelViewSample
//
//  Created by MinLison on 16/4/6.
//  Copyright © 2017年 yizmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLSExcelViewViewEnum.h"
#import "MLSIndexPath.h"

NS_ASSUME_NONNULL_BEGIN

@class MLSExcelView;

@protocol MLSExcelViewViewDataSource<NSObject>

@required
- (NSInteger)numberOfRowsInNumbersView:(MLSExcelView *)numbersView;
- (NSInteger)numberOfColumnsInNumbersView:(MLSExcelView *)numbersView;
- (__kindof NSAttributedString * _Nullable)numbersView:(MLSExcelView *)numbersView attributedStringForItemAtIndexPath:(MLSIndexPath *)indexPath;

@optional
- (__kindof UICollectionViewCell * _Nullable)numbersView:(MLSExcelView *)numbersView cellForItemAtIndexPath:(MLSIndexPath *)indexPath;
@end

@protocol MLSExcelViewViewDelegate<NSObject>

@optional
- (CGFloat)numbersView:(MLSExcelView *)numbersView heightForRow:(NSInteger)row;
- (CGFloat)numbersView:(MLSExcelView *)numbersView widthForColumn:(NSInteger)column;
- (void)numbersView:(MLSExcelView *)numbersView didSelectItemAtIndexPath:(MLSIndexPath *)indexPath;
- (void)numbersView:(MLSExcelView *)numbersView didDeselectItemAtIndexPath:(MLSIndexPath *)indexPath;
@end

///automatic caculate width, base on text length and textHorizontalMargin
UIKIT_EXTERN const CGFloat MLSExcelViewViewAutomaticDimension;

@interface MLSExcelView : UIView

@property (nonatomic, weak, nullable) IBInspectable id<MLSExcelViewViewDataSource> dataSource;
@property (nonatomic, weak, nullable) IBInspectable id<MLSExcelViewViewDelegate> delegate;

///the columns need to freeze, default is 1
@property (nonatomic) IBInspectable NSInteger columnsToFreeze;
///if the first row needs to freeze, default is NO
@property (nonatomic) IBInspectable BOOL isFreezeFirstRow;

/// 内容是否允许多选
@property(nonatomic, assign) BOOL allowsMultipleSelection;
/// 是否允许选中 默认为 YES
@property(nonatomic, assign) BOOL allowsSelection;
/// 是否允许第一列选中
@property(nonatomic, assign) BOOL allowsFreezeColumnSelection;
/// 是否允许第一行选中
@property(nonatomic, assign) BOOL allowsFreezeRowSelection;

@property(nonatomic, strong) UIColor *freezeColumnBackgroundColor;
@property(nonatomic, strong) UIColor *freezeRowBackgroundColor;
@property(nonatomic, strong) UIColor *contentBackgroundColor;

///default is MLSExcelViewSeparatorStyleSolid
@property (nonatomic) IBInspectable MLSExcelViewSeparatorStyle rowSeparatorStyle;
@property (nonatomic, strong) IBInspectable UIColor *rowSeparatorColor;

@property (nonatomic) IBInspectable MLSExcelViewSeparatorStyle columnSeparatorStyle;
@property (nonatomic, strong) IBInspectable UIColor *columnSeparatorColor;

- (void)reloadData;
- (void)reloadItemsAtIndexPaths:(NSArray<MLSIndexPath *> *)indexPaths;
/// 选中的索引
@property (nonatomic, readonly, nullable) NSArray<MLSIndexPath *> *indexPathsForSelectedItems;
///default is 100
@property (nonatomic) IBInspectable CGFloat itemMinWidth;
///default is 150
@property (nonatomic) IBInspectable CGFloat itemMaxWidth;
///default is 50
@property (nonatomic) IBInspectable CGFloat rowHeight;
///default is 10
@property (nonatomic) IBInspectable CGFloat textHorizontalMargin;

/* if - (__kindof UICollectionViewCell *)numbersView:(MLSExcelView *)numbersView cellForItemAtIndexPath:(NSIndexPath *)indexPath;  need to implementation, register cell first.
*/
- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(MLSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
