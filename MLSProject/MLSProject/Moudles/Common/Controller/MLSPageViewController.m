//
//  MLSPageViewController.m
//  MinLison
//
//  Created by MinLison on 2017/11/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSPageViewController.h"
@interface MLSPageViewController ()
@property (strong, nonatomic) HMSegmentedControl *segmentControl;
@property (strong, nonatomic, readwrite) UIView *topSortView;
@property(nonatomic, strong) UIView *topSortLine;
@property(nonatomic, strong) WZProtocolInterceptor <WMPageControllerDelegate>*delegateProxy;
@property(nonatomic, strong) WZProtocolInterceptor <WMPageControllerDataSource>*dataSourceProxy;
@end

@implementation MLSPageViewController
- (void)setDelegate:(id<WMPageControllerDelegate>)delegate
{
        if (delegate == self || delegate == nil)
        {
                self.delegateProxy.receiver = nil;
                self.delegateProxy.middleMan = nil;
                self.delegateProxy = nil;
                [super setDelegate:delegate];
                return;
        }
        self.delegateProxy = (WZProtocolInterceptor <WMPageControllerDelegate>*)[[WZProtocolInterceptor alloc] initWithInterceptedProtocol:@protocol(WMPageControllerDelegate)];
        self.delegateProxy.receiver = delegate;
        self.delegateProxy.middleMan = self;
        [super setDelegate:self.delegateProxy];
}
- (void)setDataSource:(id<WMPageControllerDataSource>)dataSource
{
        if (dataSource == self || dataSource == nil)
        {
                self.dataSourceProxy.receiver = nil;
                self.dataSourceProxy.middleMan = nil;
                self.dataSourceProxy = nil;
                [super setDataSource:dataSource];
                return;
        }
        self.dataSourceProxy = (WZProtocolInterceptor <WMPageControllerDataSource>*)[[WZProtocolInterceptor alloc] initWithInterceptedProtocol:@protocol(WMPageControllerDataSource)];
        self.dataSourceProxy.receiver = dataSource;
        self.dataSourceProxy.middleMan = self;
        [super setDataSource:self.dataSourceProxy];
}
- (void)setPageDelegate:(id<WGPageViewControllerDelegate>)pageDelegate
{
        _pageDelegate = pageDelegate;
        [self reloadData];
}
- (void)setCustomTopSortView:(BOOL)customTopSortView
{
        _customTopSortView = customTopSortView;
        if (customTopSortView && self.topSortView && [self.view.subviews containsObject:self.topSortView])
        {
                [self.topSortView removeFromSuperview];
                [self reloadData];
        }
}
- (void)initSubviews
{
        [super initSubviews];
        self.showMenuView = NO;
        self.pageAnimatable = YES;
        self.direction = (WMPageControllerScrollDirection)[self scrollDirection];
        [self configUI];
}

- (void)configUI
{
        if ([self hasTopSegment])
        {
                [self configTopSortView];
                if (!self.customTopSortView)
                {
                        [self.view bringSubviewToFront:self.topSortView];
                }
        }
}
- (void)setSegmentLayoutEdgeInsets:(UIEdgeInsets)segmentLayoutEdgeInsets
{
        _segmentLayoutEdgeInsets = segmentLayoutEdgeInsets;
        if (_segmentControl && _segmentControl.superview) {
                [_segmentControl mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self.topSortView).valueOffset([NSValue valueWithUIEdgeInsets:segmentLayoutEdgeInsets]);
                }];
        }
        
}
- (void)setTopSortBottomLineColor:(UIColor *)topSortBottomLineColor
{
        _topSortBottomLineColor = topSortBottomLineColor;
        self.topSortLine.backgroundColor = topSortBottomLineColor;
}
/** 顶部分类view */
- (void)configTopSortView
{
        
        self.topSortView = [[UIView alloc] init];
        self.topSortView.backgroundColor = [UIColor whiteColor];
        if (!self.customTopSortView)
        {
                [self.view addSubview:self.topSortView];
        }
        [self.topSortView addSubview:self.segmentControl];
        
        //底部线
        UIView *line = [[UIView alloc] init];
        self.topSortLine = line;
        line.translatesAutoresizingMaskIntoConstraints = NO;
        line.backgroundColor = self.topSortBottomLineColor ?: UIColorHex(0xe6e6e6);
        [self.segmentControl insertSubview:line atIndex:0];
        
        //遮罩
        UIImageView *shadeImageView = [[UIImageView alloc] init];
        shadeImageView.translatesAutoresizingMaskIntoConstraints = NO;
        shadeImageView.contentMode = UIViewContentModeScaleToFill;
        shadeImageView.clipsToBounds = YES;
        shadeImageView.hidden = YES;
        [self.topSortView addSubview:shadeImageView];
        
        [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.topSortView).valueOffset([NSValue valueWithUIEdgeInsets:self.segmentLayoutEdgeInsets]);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.segmentControl);
                make.bottom.equalTo(self.segmentControl.mas_bottom);
                make.height.mas_equalTo(1);
        }];
        
        [shadeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.topSortView);
                make.height.mas_equalTo(3);
                make.top.equalTo(self.topSortView.mas_bottom);
        }];
        if (!self.customTopSortView)
        {
                [self.topSortView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.equalTo(self.view);
                        make.top.equalTo(self.mas_topLayoutGuideBottom);
                        make.height.mas_equalTo(__WGHeight(40.0));
                }];
        }
        
}

- (void)setSegmentTitles:(NSArray<NSString *> *)segmentTitles
{
        _segmentTitles = segmentTitles;
        _segmentControl.sectionTitles = segmentTitles;
        if (segmentTitles.count <= 5) {
                _segmentControl.segmentWidthStyle               = HMSegmentedControlSegmentWidthStyleFixed;
        }else {
                _segmentControl.segmentWidthStyle               = HMSegmentedControlSegmentWidthStyleDynamic;
        }
        [_segmentControl setNeedsDisplay];
}
- (void)enableScroll:(BOOL)enable
{
        self.scrollView.scrollEnabled = enable;
}
- (void)reloadData
{
        [super reloadData];
        if ([self hasTopSegment])
        {
                if (!self.customTopSortView)
                {
                        [self.view bringSubviewToFront:self.topSortView];
                }
                _segmentControl.sectionTitles = self.segmentTitles;
                [_segmentControl reloadData];
                [_segmentControl setNeedsDisplay];
        }
}
/// MARK: - WMPageViewController
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
        if ([self.dataSourceProxy.receiver respondsToSelector:_cmd]) {
                return [self.dataSourceProxy.receiver numbersOfChildControllersInPageController:pageController];
        }
        return [self countOfContentItems];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
        if ([self.dataSourceProxy.receiver respondsToSelector:_cmd]) {
                return [self.dataSourceProxy.receiver pageController:pageController titleAtIndex:index];
        }
        if (self.showMenuView && index >=0 && index <= self.segmentTitles.count - 1) {
                return self.segmentTitles[index];
        }
        return @"";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
        if ([self.dataSourceProxy.receiver respondsToSelector:_cmd]) {
                return [self.dataSourceProxy.receiver pageController:pageController viewControllerAtIndex:index];
        }
        UIViewController *vc = [self contentControllerAtIndex:index];
        if (vc)
        {
                [self configController:vc atIndex:index];
                return vc;
        }
        return [[UIViewController alloc] init];
}
- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
        if ([self.delegateProxy.receiver respondsToSelector:_cmd]) {
                [self.delegateProxy.receiver pageController:pageController willEnterViewController:viewController withInfo:info];
        }
        [self configController:viewController atIndex:info.infoIndexValue];
}
- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
        if ([self.delegateProxy.receiver respondsToSelector:_cmd]) {
                [self.delegateProxy.receiver pageController:pageController didEnterViewController:viewController withInfo:info];
        }
        [self.segmentControl setSelectedSegmentIndex:info.infoIndexValue animated:YES];
        [self controllerDidShow:viewController atIndex:info.infoIndexValue];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
        if ([self.delegateProxy.receiver respondsToSelector:_cmd]) {
                return [self.delegateProxy.receiver pageController:pageController preferredFrameForContentView:contentView];
        }
        if ([self hasTopSegment] && !self.customTopSortView) {
                CGFloat marginHeight = CGRectGetMaxY(self.topSortView.frame);
                return CGRectMake(0, marginHeight, self.view.frame.size.width, self.view.frame.size.height - marginHeight);
        }
        return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

/**
 选中控制器
 只有当 hastopSetment 返回 NO 的时候有效
 @param index 索引
 */
- (void)selectedController:(NSInteger)index
{
        BOOL oldAnimation = self.pageAnimatable;
        self.pageAnimatable = NO;
        self.selectIndex = (int)index;
        self.pageAnimatable = oldAnimation;
}

/**
 选中控制器, 具有动画效果 (暂时只支持歌单)
 
 @param index 索引
 @param animation 动画
 */
- (void)selectedController:(NSInteger)index animation:(BOOL)animation
{
        BOOL oldAnimation = self.pageAnimatable;
        self.pageAnimatable = YES;
        self.selectIndex = (int)index;
        self.pageAnimatable = oldAnimation;
}
- (BOOL)hasTopSegment
{
        if ([self.pageDelegate respondsToSelector:_cmd]) {
                return [self.pageDelegate hasTopSegment];
        }
        return YES;
}
/**
 滚动方向
 
 @return return value description
 */
- (WGSegmentScrollDirection )scrollDirection
{
        if ([self.pageDelegate respondsToSelector:_cmd]) {
               return [self.pageDelegate scrollDirection];
        }
        return WGSegmentScrollDirectionHorizontal;
}



- (NSInteger)countOfContentItems
{
        if ([self.pageDelegate respondsToSelector:_cmd]) {
               return [self.pageDelegate countOfContentItems];
        }
        return 0;
}
- (UIViewController *)contentControllerAtIndex:(NSInteger)index
{
        if ([self.pageDelegate respondsToSelector:_cmd]) {
               return [self.pageDelegate contentControllerAtIndex:index];
        }
        return nil;
}
- (void)configController:(UIViewController *)controller atIndex:(NSInteger)index
{
        if ([self.pageDelegate respondsToSelector:_cmd]) {
                [self.pageDelegate configController:controller atIndex:index];
        }
}
- (void)controllerDidShow:(UIViewController *)controller atIndex:(NSInteger)index
{
        if ([self.pageDelegate respondsToSelector:_cmd]) {
                [self.pageDelegate controllerDidShow:controller atIndex:index];
        }
}
//// View
- (HMSegmentedControl *)segmentControl
{
        if (!_segmentControl)
        {
                _segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 43)];
                _segmentControl.translatesAutoresizingMaskIntoConstraints = NO;
                _segmentControl.shouldAnimateUserSelection = YES;
                _segmentControl.selectionIndicatorHeight        = 2.0;
                _segmentControl.verticalDividerEnabled          = NO;
                _segmentControl.selectionStyle                  = HMSegmentedControlSelectionStyleTextWidthStripe;
                _segmentControl.type                            = HMSegmentedControlTypeText;
                _segmentControl.selectionIndicatorLocation      = HMSegmentedControlSelectionIndicatorLocationDown;
                _segmentControl.segmentWidthStyle               = HMSegmentedControlSegmentWidthStyleDynamic;
                _segmentControl.selectionIndicatorEdgeInsets    = UIEdgeInsetsMake(0, 3, 0, 3);
                _segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
                _segmentControl.backgroundColor                 = [UIColor whiteColor];
                _segmentControl.titleTextAttributes             = @{NSFontAttributeName : WGBoldSystem15Font, NSForegroundColorAttributeName : UIColorGray5};
                _segmentControl.selectedTitleTextAttributes     = @{NSFontAttributeName : WGBoldSystem15Font, NSForegroundColorAttributeName : UIColorHex(0x333333)};
                _segmentControl.selectionIndicatorColor         = UIColorHex(0x333333);
                _segmentControl.selectedSegmentIndex            = 0;
                self.selectIndex = 0;
                @weakify(self);
                [_segmentControl setIndexChangeBlock:^(NSInteger index) {
                        @strongify(self);
                        self.selectIndex = (int)index;
                }];
        }
        return _segmentControl;
}


@end
