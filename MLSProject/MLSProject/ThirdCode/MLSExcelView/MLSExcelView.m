//
//  MLSExcelView.m
//  MLSExcelViewSample
//
//  Created by MinLison on 16/4/6.
//  Copyright © 2017年 yizmh. All rights reserved.
//

#import "MLSExcelView.h"
#import "MLSExcelViewCollectionCell.h"
#import "MLSExcelViewCollectionHeaderView.h"
#import "NSString+MLSExcelView.h"
#import "MLSExcelViewViewMarcos.h"
#import <objc/runtime.h>

const CGFloat MLSExcelViewViewAutomaticDimension = 1646.1646;

NSString * const CellReuseIdentifer = @"com.yizmh.numbersview.collectioncell";
NSString * const HeaderReuseIdentifer = @"com.yizmh.numbersview.collectionheader";

@interface MLSExcelView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *headerFreezeCollectionView; // 左上角视图
@property (nonatomic, strong) UICollectionView *bodyFreezeCollectionView;  // 左侧固定列

@property (nonatomic, strong) UIScrollView *slideScrollView;

@property (nonatomic, strong) UICollectionView *headerSlideCollectionView; // 顶部固定行
@property (nonatomic, strong) UICollectionView *bodySlideCollectionView;  // 内容视图

@property (nonatomic, strong) UIBezierPath *freezeColumnSeparatorPath;
@property (nonatomic, strong) UIBezierPath *slideColumnSeparatorPath;

@property (nonatomic, strong) CAShapeLayer *freezeColumnSeparatorLayer;
@property (nonatomic, strong) CAShapeLayer *slideColumnSeparatorLayer;

@property (nonatomic, strong) UIBezierPath *horizontalDivideShadowPath;
@property (nonatomic, strong) UIBezierPath *verticalDivideShadowPath;

@property (nonatomic, strong) CAShapeLayer *horizontalDivideShadowLayer;
@property (nonatomic, strong) CAShapeLayer *verticalDivideShadowLayer;

@property (nonatomic) CGFloat columns;
@property (nonatomic) CGFloat rows;

@property (nonatomic) CGFloat freezeColumnsWidth;
@property (nonatomic) CGFloat slideColumnWidth;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnWidths;

@property (nonatomic) CGFloat allRowsHeight;
@property (nonatomic) CGFloat heightForFirstRow;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *rowHeights;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation MLSExcelView
#pragma mark - Override

- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                [self setup];
        }
        return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
        self = [super initWithCoder:aDecoder];
        if (self) {
                [self setup];
        }
        return self;
}

- (void)layoutSubviews {
        [super layoutSubviews];
        [self updateUI];
}

- (void)dealloc {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public

- (void)reloadData {
        
        if (![self prepareReload]) {
                return;
        }
        
        [_headerFreezeCollectionView reloadData];
        [_headerSlideCollectionView reloadData];
        [_bodyFreezeCollectionView reloadData];
        [_bodySlideCollectionView reloadData];
}

- (void)reloadItemsAtIndexPaths:(NSArray<MLSIndexPath *> *)indexPaths {
        
        
        NSMutableArray *headerFreezeIndexPaths = [NSMutableArray new];
        NSMutableArray *headerSlideIndexPaths = [NSMutableArray new];
        NSMutableArray *freezeIndexPaths = [NSMutableArray new];
        NSMutableArray *slideIndexPaths = [NSMutableArray new];
        
        for (MLSIndexPath *indexPath in indexPaths) {
                //exsit header
                if (_isFreezeFirstRow) {
                        //if header
                        if (indexPath.row == 0) {
                                
                                //if freeze
                                if (indexPath.column < _columnsToFreeze) {
                                        
                                        [headerFreezeIndexPaths addObject:[NSIndexPath indexPathForItem:indexPath.column inSection:indexPath.row]];
                                        
                                } else {
                                        
                                        [headerSlideIndexPaths addObject:[NSIndexPath indexPathForItem:indexPath.column - _columnsToFreeze inSection:indexPath.row]];
                                }
                                //body
                        } else {
                                
                                //if freeze
                                if (indexPath.column < _columnsToFreeze) {
                                        
                                        [freezeIndexPaths addObject:[NSIndexPath indexPathForItem:indexPath.column inSection:indexPath.row - 1]];
                                } else {
                                        
                                        [slideIndexPaths addObject:[NSIndexPath indexPathForItem:indexPath.column - _columnsToFreeze inSection:indexPath.row - 1]];
                                }
                        }
                        
                        //body only
                } else {
                        //if freeze
                        if (indexPath.column < _columnsToFreeze) {
                                
                                [freezeIndexPaths addObject:[NSIndexPath indexPathForItem:indexPath.column inSection:indexPath.row]];
                        } else {
                                
                                [slideIndexPaths addObject:[NSIndexPath indexPathForItem:indexPath.column - _columnsToFreeze inSection:indexPath.row]];
                        }
                }
        }
        
        if (![self prepareReload]) {
                return;
        }
        
        [_headerFreezeCollectionView reloadItemsAtIndexPaths:headerFreezeIndexPaths];
        [_headerSlideCollectionView reloadItemsAtIndexPaths:headerSlideIndexPaths];
        [_bodyFreezeCollectionView reloadItemsAtIndexPaths:freezeIndexPaths];
        [_bodySlideCollectionView reloadItemsAtIndexPaths:slideIndexPaths];
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
        [_headerFreezeCollectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
        [_headerSlideCollectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
        [_bodyFreezeCollectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
        [_bodySlideCollectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier {
        [_headerFreezeCollectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        [_headerSlideCollectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        [_bodyFreezeCollectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        [_bodySlideCollectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(MLSIndexPath *)indexPath {
        NSInteger row = 0;
        NSInteger column = 0;
        UICollectionView *collectionView = nil;
        if (_isFreezeFirstRow) {
                
                if (indexPath.row < 1) {
                        if (indexPath.column < _columnsToFreeze) {
                                collectionView = _headerFreezeCollectionView;
                                row = indexPath.row;
                                column = indexPath.column;
                                
                        } else {
                                collectionView = _headerSlideCollectionView;
                                row = indexPath.row;
                                column = indexPath.column - _columnsToFreeze;
                        }
                } else {
                        if (indexPath.column < _columnsToFreeze) {
                                collectionView = _bodyFreezeCollectionView;
                                row = indexPath.row - 1;
                                column = indexPath.column;
                        } else {
                                collectionView = _bodySlideCollectionView;
                                row = indexPath.row - 1;
                                column = indexPath.column - _columnsToFreeze;
                        }
                }
                
        } else {
                
                if (indexPath.column < _columnsToFreeze) {
                        collectionView = _bodyFreezeCollectionView;
                        row = indexPath.row;
                        column = indexPath.column;
                } else {
                        collectionView = _bodySlideCollectionView;
                        row = indexPath.row;
                        column = indexPath.column - _columnsToFreeze;
                }
        }
        return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForItem:column inSection:row]];
}

#pragma mark - Notification

- (void)handleNotification:(NSNotification *)noti {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        
        if (orientation != UIDeviceOrientationPortraitUpsideDown) {
                [UIView animateWithDuration:0.25 animations:^{
                        [self updateUI];
                }];
        }
}

#pragma mark - Private

- (void)setup {
        self.allowsSelection = YES;
        self.allowsFreezeRowSelection = NO;
        self.allowsFreezeColumnSelection = NO;
        [self setupVars];
        [self setupViews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)setupVars {
        self.clipsToBounds = YES;
        
        _itemMinWidth = 100;
        _itemMaxWidth = 150;
        _rowHeight = 50;
        _textHorizontalMargin = 10;
        
        _columnsToFreeze = 1;
        
        _rowSeparatorStyle = MLSExcelViewSeparatorStyleDotted;
        _columnSeparatorStyle = MLSExcelViewSeparatorStyleSolid;
}

- (void)setupViews {
        
        self.clipsToBounds = YES;
        
        [self addSubview:self.headerFreezeCollectionView];
        [self addSubview:self.bodyFreezeCollectionView];
        
        [self addSubview:self.slideScrollView];
        [_slideScrollView addSubview:self.headerSlideCollectionView];
        [_slideScrollView addSubview:self.bodySlideCollectionView];
        
        [self.layer addSublayer:self.horizontalDivideShadowLayer];
        [self.layer addSublayer:self.verticalDivideShadowLayer];
        [self.layer addSublayer:self.freezeColumnSeparatorLayer];
        [_slideScrollView.layer addSublayer:self.slideColumnSeparatorLayer];
}

- (BOOL)prepareReload {
        if ([_dataSource respondsToSelector:@selector(numberOfColumnsInNumbersView:)] &&
            [_dataSource respondsToSelector:@selector(numberOfRowsInNumbersView:)] &&
            [_dataSource respondsToSelector:@selector(numbersView:attributedStringForItemAtIndexPath:)]) {
                
                [self caculate];
                [self updateUI];
                
                return YES;
        } else {
                return NO;
        }
}

- (void)caculate {
        
        _columns = [_dataSource numberOfColumnsInNumbersView:self];
        _rows = [_dataSource numberOfRowsInNumbersView:self];
        
        [self caculateWidths];
        [self caculateHeights];
        [self caculateSepartorPath];
        [self caculateDividePath];
}

- (void)caculateWidths {
        _columnWidths = [NSMutableArray array];
        
        _freezeColumnsWidth = 0;
        _slideColumnWidth = 0;
        
        //遍历列
        for (NSInteger column = 0; column < _columns; column ++) {
                
                BOOL needCaculate = NO;
                CGFloat columnWidth = 0;
                if ([_delegate respondsToSelector:@selector(numbersView:widthForColumn:)]) {
                        columnWidth = [_delegate numbersView:self widthForColumn:column];
                        if (columnWidth == MLSExcelViewViewAutomaticDimension) {
                                needCaculate = YES;
                        }
                } else {
                        needCaculate = YES;
                }
                
                if (needCaculate) {
                        columnWidth = 0;
                        //遍历行
                        for (NSInteger row = 0; row < _rows; row ++) {
                                
                                MLSIndexPath *indexPath = [MLSIndexPath indexPathForColumn:column inRow:row];
                                NSString *string = [_dataSource numbersView:self attributedStringForItemAtIndexPath:indexPath].string;
                                
                                CGFloat itemWidth = 0;
                                if (string.length) {
                                        CGSize stringSize = [string MLS_sizeWithFont:[UIFont systemFontOfSize:kDefaultFontSize] constraint:CGSizeMake(_itemMaxWidth, MAXFLOAT)];
                                        itemWidth = stringSize.width + 2 * _textHorizontalMargin;
                                }
                                
                                if (itemWidth >= columnWidth) {
                                        columnWidth = itemWidth;
                                }
                                
                                columnWidth = ceil(MAX(_itemMinWidth, MIN(_itemMaxWidth, columnWidth)));
                        }
                }
                
                [_columnWidths addObject:@(columnWidth)];
                
                if (column < _columnsToFreeze) {
                        _freezeColumnsWidth += columnWidth;
                } else {
                        _slideColumnWidth += columnWidth;
                }
        }
}

- (void)caculateHeights {
        _rowHeights = [NSMutableArray array];
        _heightForFirstRow = 0;
        _allRowsHeight = 0;
        for (NSInteger row = 0; row < _rows; row ++) {
                
                CGFloat rowHeight = _rowHeight;
                if ([_delegate respondsToSelector:@selector(numbersView:heightForRow:)]) {
                        rowHeight = [_delegate numbersView:self heightForRow:row];
                }
                [_rowHeights addObject:@(rowHeight)];
                
                if (row == 0) {
                        _heightForFirstRow = rowHeight;
                }
                
                _allRowsHeight += rowHeight;
        }
}

- (void)caculateSepartorPath {
        if (_columnWidths.count <= _columnsToFreeze)
        {
                return;
        }
        CGFloat targetWidth = 0;
        UIBezierPath *freezePath = [UIBezierPath bezierPath];
        for (NSNumber *columnWidth in [_columnWidths subarrayWithRange:NSMakeRange(0, _columnsToFreeze)]) {
                targetWidth += columnWidth.floatValue;
                [freezePath moveToPoint:CGPointMake(targetWidth, 0)];
                [freezePath addLineToPoint:CGPointMake(targetWidth, _allRowsHeight)];
        }
        _freezeColumnSeparatorPath = freezePath;
        
        UIBezierPath *slidePath = [UIBezierPath bezierPath];
        targetWidth = 0;
        for (NSNumber *columnWidth in [_columnWidths subarrayWithRange:NSMakeRange(_columnsToFreeze, _columnWidths.count - _columnsToFreeze - 1)]) {
                targetWidth += columnWidth.floatValue;
                [slidePath moveToPoint:CGPointMake(targetWidth, 0)];
                [slidePath addLineToPoint:CGPointMake(targetWidth, _allRowsHeight)];
        }
        _slideColumnSeparatorPath = slidePath;
}

- (void)caculateDividePath {
        CGFloat contentWidth = _freezeColumnsWidth + _slideColumnWidth;
        _horizontalDivideShadowPath = [UIBezierPath bezierPath];
        [_horizontalDivideShadowPath moveToPoint:CGPointMake(0, _heightForFirstRow)];
        [_horizontalDivideShadowPath addLineToPoint:CGPointMake(contentWidth, _heightForFirstRow)];
        
        CGFloat contentHeight = _allRowsHeight;
        _verticalDivideShadowPath = [UIBezierPath bezierPath];
        [_verticalDivideShadowPath moveToPoint:CGPointMake(_freezeColumnsWidth, 0)];
        [_verticalDivideShadowPath addLineToPoint:CGPointMake(_freezeColumnsWidth, contentHeight)];
}

- (void)updateUI {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        
        if (_isFreezeFirstRow) {
                
                _headerFreezeCollectionView.frame = CGRectMake(0, 0,
                                                               _freezeColumnsWidth , _heightForFirstRow);
                
                _bodyFreezeCollectionView.frame = CGRectMake(0, _heightForFirstRow,
                                                             _freezeColumnsWidth, height - _heightForFirstRow);
                
                _headerSlideCollectionView.frame = CGRectMake(0, 0,
                                                              _slideColumnWidth, _heightForFirstRow);
                
                _bodySlideCollectionView.frame = CGRectMake(0, _heightForFirstRow,
                                                            _slideColumnWidth, height - _heightForFirstRow);
                
        } else {
                
                _bodyFreezeCollectionView.frame = CGRectMake(0, 0,
                                                             _freezeColumnsWidth, height);
                
                _bodySlideCollectionView.frame = CGRectMake(0, 0,
                                                            _slideColumnWidth, height);
        }
        
        _slideScrollView.frame = CGRectMake(_freezeColumnsWidth, 0,
                                            width - _freezeColumnsWidth, height);
        _slideScrollView.contentSize = CGSizeMake(_slideColumnWidth, height);
        
        _slideColumnSeparatorLayer.path = _slideColumnSeparatorPath.CGPath;
        _freezeColumnSeparatorLayer.path = _freezeColumnSeparatorPath.CGPath;
        
        _horizontalDivideShadowLayer.path = _horizontalDivideShadowPath.CGPath;
        _verticalDivideShadowLayer.path = _verticalDivideShadowPath.CGPath;
}

#pragma mark - Getter

- (UICollectionView *)headerFreezeCollectionView {
        if (!_headerFreezeCollectionView) {
                _headerFreezeCollectionView = [self initializeCollectionView];
        }
        return _headerFreezeCollectionView;
}

- (UICollectionView *)bodyFreezeCollectionView {
        if (!_bodyFreezeCollectionView) {
                _bodyFreezeCollectionView = [self initializeCollectionView];
        }
        return _bodyFreezeCollectionView;
}

- (UIScrollView *)slideScrollView {
        if (!_slideScrollView) {
                _slideScrollView = [UIScrollView new];
                _slideScrollView.bounces = NO;
                _slideScrollView.showsHorizontalScrollIndicator = NO;
                _slideScrollView.delegate = self;
        }
        return _slideScrollView;
}

- (UICollectionView *)headerSlideCollectionView {
        if (!_headerSlideCollectionView) {
                _headerSlideCollectionView = [self initializeCollectionView];
        }
        return _headerSlideCollectionView;
}

- (UICollectionView *)bodySlideCollectionView {
        if (!_bodySlideCollectionView) {
                _bodySlideCollectionView = [self initializeCollectionView];
        }
        return _bodySlideCollectionView;
}

- (CAShapeLayer *)freezeColumnSeparatorLayer {
        if (!_freezeColumnSeparatorLayer) {
                _freezeColumnSeparatorLayer = [self initializeLayer];
                _freezeColumnSeparatorLayer.shadowOpacity = 0;
                _freezeColumnSeparatorLayer.lineWidth = k1PxSize;
        }
        return _freezeColumnSeparatorLayer;
}

- (CAShapeLayer *)slideColumnSeparatorLayer {
        if (!_slideColumnSeparatorLayer) {
                _slideColumnSeparatorLayer = [self initializeLayer];
                _slideColumnSeparatorLayer.shadowOpacity = 0;
                _slideColumnSeparatorLayer.lineWidth = k1PxSize;
        }
        return _slideColumnSeparatorLayer;
}

- (CAShapeLayer *)horizontalDivideShadowLayer {
        if (!_horizontalDivideShadowLayer) {
                _horizontalDivideShadowLayer = [self initializeLayer];
                _horizontalDivideShadowLayer.shadowOffset = CGSizeMake(0, 3);
                _horizontalDivideShadowLayer.hidden = YES;
        }
        return _horizontalDivideShadowLayer;
}

- (CAShapeLayer *)verticalDivideShadowLayer {
        if (!_verticalDivideShadowLayer) {
                _verticalDivideShadowLayer = [self initializeLayer];
                _verticalDivideShadowLayer.hidden = YES;
        }
        return _verticalDivideShadowLayer;
}
- (NSArray<MLSIndexPath *> *)indexPathsForSelectedItems
{
        NSMutableArray <MLSIndexPath *>*allIndexPaths = [NSMutableArray array];
        NSArray <UICollectionView *>*collectionViews = @[self.bodyFreezeCollectionView,self.bodySlideCollectionView,self.headerFreezeCollectionView,self.headerSlideCollectionView];
        [collectionViews enumerateObjectsUsingBlock:^(UICollectionView * _Nonnull collectionView, NSUInteger idx, BOOL * _Nonnull stop) {
                [collectionView.indexPathsForSelectedItems enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
                        [allIndexPaths addObject:[self convertIndexPath:indexPath fromCollectionView:collectionView]];
                }];
        }];
        return allIndexPaths;
}
#pragma mark - Helper

- (UICollectionView *)initializeCollectionView {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        UICollectionView *c = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        c.dataSource = self;
        c.delegate = self;
        [c registerClass:[MLSExcelViewCollectionCell class] forCellWithReuseIdentifier:CellReuseIdentifer];
        [c registerClass:[MLSExcelViewCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderReuseIdentifer];
        c.backgroundColor = [UIColor clearColor];
        c.showsVerticalScrollIndicator = NO;
        c.bounces = NO;
        c.translatesAutoresizingMaskIntoConstraints = NO;
        [self adjustAllCollectionView];
        return c;
}

- (CAShapeLayer *)initializeLayer {
        CAShapeLayer *s = [CAShapeLayer new];
        s.strokeColor = [UIColor lightGrayColor].CGColor;
        s.shadowColor = [UIColor blackColor].CGColor;
        s.shadowOffset = CGSizeMake(2, 0);
        s.shadowOpacity = 1;
        s.lineWidth = k1PxSize;
        return s;
}

- (MLSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath fromCollectionView:(UICollectionView *)collectionView {
        
        NSInteger row = 0;
        NSInteger column = 0;
        if (collectionView == _headerFreezeCollectionView) {
                row = indexPath.section;
                column = indexPath.item;
        } else if (collectionView == _headerSlideCollectionView) {
                row = indexPath.section;
                column = indexPath.item + _columnsToFreeze;
        } else if (collectionView == _bodyFreezeCollectionView) {
                row = indexPath.section + (_isFreezeFirstRow ? 1 : 0);
                column = indexPath.item;
        } else if (collectionView == _bodySlideCollectionView){
                row = indexPath.section + (_isFreezeFirstRow ? 1 : 0);
                column = indexPath.item + _columnsToFreeze;
        }
        
        return [MLSIndexPath indexPathForColumn:column inRow:row];
}
- (void)adjustAllCollectionView
{
        // select
        /// 左侧固定列
        _bodyFreezeCollectionView.allowsSelection = self.allowsSelection && self.allowsFreezeColumnSelection;
        _bodyFreezeCollectionView.allowsMultipleSelection = self.allowsSelection && self.allowsMultipleSelection && self.allowsFreezeColumnSelection;
        _bodyFreezeCollectionView.backgroundColor = self.freezeColumnBackgroundColor;
        /// 内容视图
        _bodySlideCollectionView.allowsSelection = self.allowsSelection;
        _bodySlideCollectionView.allowsMultipleSelection = self.allowsSelection && self.allowsMultipleSelection;
        _bodySlideCollectionView.backgroundColor = self.contentBackgroundColor;
        /// 顶部视图
        _headerSlideCollectionView.allowsSelection = self.allowsSelection && self.allowsFreezeRowSelection;
        _headerSlideCollectionView.allowsMultipleSelection = self.allowsSelection && self.allowsMultipleSelection && self.allowsFreezeRowSelection;
        _headerSlideCollectionView.backgroundColor = self.freezeRowBackgroundColor;
        /// 左上角
        _headerFreezeCollectionView.allowsSelection = self.allowsSelection && self.allowsFreezeRowSelection && self.allowsFreezeColumnSelection;
        _headerFreezeCollectionView.allowsMultipleSelection = self.allowsSelection && self.allowsMultipleSelection && self.allowsFreezeRowSelection && self.allowsFreezeColumnSelection;
        _headerFreezeCollectionView.backgroundColor = self.freezeRowBackgroundColor;
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
        
        CGFloat numbersOfSectionsInHeader = (_isFreezeFirstRow ? 1 : 0);
        if (collectionView == _headerFreezeCollectionView ||
            collectionView == _headerSlideCollectionView) {
                return numbersOfSectionsInHeader;
        } else {
                return [_dataSource numberOfRowsInNumbersView:self] - numbersOfSectionsInHeader;
        }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        
        if (collectionView == _headerFreezeCollectionView ||
            collectionView == _bodyFreezeCollectionView) {
                return _columnsToFreeze;
        } else {
                return [_dataSource numberOfColumnsInNumbersView:self] - _columnsToFreeze;
        }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
        MLSIndexPath *convertedIndexPath = [self convertIndexPath:indexPath fromCollectionView:collectionView];
        UICollectionViewCell *cell = nil;
        if ([_dataSource respondsToSelector:@selector(numbersView:cellForItemAtIndexPath:)]) {
                cell = [_dataSource numbersView:self cellForItemAtIndexPath:convertedIndexPath];
        }
        if (!cell) {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifer forIndexPath:indexPath];
                ((MLSExcelViewCollectionCell *)cell).textHorizontalMargin = _textHorizontalMargin;
                
                NSAttributedString *attributedString = [_dataSource numbersView:self attributedStringForItemAtIndexPath:convertedIndexPath];
                ((MLSExcelViewCollectionCell *)cell).attributedString = attributedString;
        }
        return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
        
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
                MLSExcelViewCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderReuseIdentifer forIndexPath:indexPath];
                headerView.rowSeparatorStyle = _rowSeparatorStyle;
                headerView.rowSeparatorColor = _rowSeparatorColor;
                
                return headerView;
        } else {
                return [UICollectionReusableView new];
        }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        MLSIndexPath *convertedIndexPath = [self convertIndexPath:indexPath fromCollectionView:collectionView];
        return CGSizeMake(_columnWidths[convertedIndexPath.column].floatValue, _rowHeights[convertedIndexPath.row].floatValue);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
        BOOL isFreezeCollectionView = (collectionView == _headerFreezeCollectionView) || (collectionView == _headerSlideCollectionView);
        if (section == 0 && isFreezeCollectionView) {
                return CGSizeZero;
        } else {
                return CGSizeMake(collectionView.bounds.size.width, 1);
        }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        
        if (![_delegate respondsToSelector:@selector(numbersView:didSelectItemAtIndexPath:)]) {
                return;
        }
        
        MLSIndexPath *convertedIndexPath = [self convertIndexPath:indexPath fromCollectionView:collectionView];
        [_delegate numbersView:self didSelectItemAtIndexPath:convertedIndexPath];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
        if (![_delegate respondsToSelector:@selector(numbersView:didDeselectItemAtIndexPath:)]) {
                return;
        }
        MLSIndexPath *convertedIndexPath = [self convertIndexPath:indexPath fromCollectionView:collectionView];
        [_delegate numbersView:self didDeselectItemAtIndexPath:convertedIndexPath];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        if (scrollView != _slideScrollView) {
                [_bodyFreezeCollectionView setContentOffset:scrollView.contentOffset];
                [_bodySlideCollectionView setContentOffset:scrollView.contentOffset];
                
                if (scrollView.contentOffset.y > 0) {
                        _horizontalDivideShadowLayer.hidden = !_isFreezeFirstRow;
                } else {
                        _horizontalDivideShadowLayer.hidden = YES;
                }
                
        } else {
                if (scrollView.contentOffset.x > 0) {
                        _verticalDivideShadowLayer.hidden = (_columnsToFreeze == 0);
                } else {
                        _verticalDivideShadowLayer.hidden = YES;
                }
        }
}

#pragma mark - Setter
- (void)setAllowsSelection:(BOOL)allowsSelection
{
        _allowsSelection = allowsSelection;
        [self adjustAllCollectionView];
}
- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
        _allowsMultipleSelection = allowsMultipleSelection;
        [self adjustAllCollectionView];
}
- (void)setAllowsFreezeRowSelection:(BOOL)allowsFreezeRowSelection
{
        _allowsFreezeRowSelection = allowsFreezeRowSelection;
        [self adjustAllCollectionView];
}
- (void)setAllowsFreezeColumnSelection:(BOOL)allowsFreezeColumnSelection
{
        _allowsFreezeColumnSelection = allowsFreezeColumnSelection;
        [self adjustAllCollectionView];
}

- (void)setFreezeRowBackgroundColor:(UIColor *)freezeRowBackgroundColor
{
        _freezeRowBackgroundColor = freezeRowBackgroundColor;
        [self adjustAllCollectionView];
}
- (void)setFreezeColumnBackgroundColor:(UIColor *)freezeColumnBackgroundColor
{
        _freezeColumnBackgroundColor = freezeColumnBackgroundColor;
        [self adjustAllCollectionView];
}
- (void)setContentBackgroundColor:(UIColor *)contentBackgroundColor
{
        _contentBackgroundColor = contentBackgroundColor;
        [self adjustAllCollectionView];
}

- (void)setRowSeparatorStyle:(MLSExcelViewSeparatorStyle)rowSeparatorStyle {
        if (_rowSeparatorStyle != rowSeparatorStyle) {
                _rowSeparatorStyle = rowSeparatorStyle;
                [self reloadData];
        }
}

- (void)setRowSeparatorColor:(UIColor *)rowSeparatorColor {
        if (_rowSeparatorColor != rowSeparatorColor) {
                _rowSeparatorColor = rowSeparatorColor;
                [self reloadData];
        }
}

- (void)setColumnSeparatorStyle:(MLSExcelViewSeparatorStyle)columnSeparatorStyle {
        if (_columnSeparatorStyle != columnSeparatorStyle) {
                _columnSeparatorStyle = columnSeparatorStyle;
                _slideColumnSeparatorLayer.hidden = NO;
                _freezeColumnSeparatorLayer.hidden = NO;
                if (columnSeparatorStyle == MLSExcelViewSeparatorStyleNone) {
                        _slideColumnSeparatorLayer.hidden = YES;
                        _freezeColumnSeparatorLayer.hidden = YES;
                } else if (columnSeparatorStyle == MLSExcelViewSeparatorStyleDotted) {
                        _slideColumnSeparatorLayer.lineDashPattern = @[@2];
                        _freezeColumnSeparatorLayer.lineDashPattern = @[@2];
                } else if (columnSeparatorStyle == MLSExcelViewSeparatorStyleSolid){
                        _slideColumnSeparatorLayer.lineDashPattern = nil;
                        _freezeColumnSeparatorLayer.lineDashPattern = nil;
                }
        }
}

- (void)setColumnSeparatorColor:(UIColor *)columnSeparatorColor {
        if (_columnSeparatorColor != columnSeparatorColor) {
                _columnSeparatorColor = columnSeparatorColor;
                _slideColumnSeparatorLayer.strokeColor = columnSeparatorColor.CGColor;
                _freezeColumnSeparatorLayer.strokeColor = columnSeparatorColor.CGColor;
        }
}

@end




