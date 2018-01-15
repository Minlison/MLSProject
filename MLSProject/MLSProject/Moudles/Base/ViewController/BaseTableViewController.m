//
//  BaseTableViewController.m
//  MinLison
//
//  Created by MinLison on 2017/10/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTableViewController.h"
#import "QMUICore.h"
#import "QMUITableView.h"
#import "QMUIEmptyView.h"
#import "QMUILabel.h"
#import "UIScrollView+QMUI.h"
#import "UITableView+QMUI.h"
#import "UICollectionView+QMUI.h"
#import "BaseTableControllerView.h"
#import "BaseLoadingView.h"


const UIEdgeInsets BaseCommonTableViewControllerInitialContentInsetNotSet = {-1, -1, -1, -1};

@interface BaseTableViewController ()
@property(nonatomic, assign) BOOL hasSetInitialContentInset;
@property(nonatomic, assign) BOOL hasHideTableHeaderViewInitial;
@property(nonatomic, assign) NSTimeInterval lastLoadingTimeInterval;
@property(nonatomic, strong, readwrite) BaseTableViewDelegate *privateDelegate;
//@property(nonatomic, strong) BaseTableViewDataSource *privateDataSource;
@end

@implementation BaseTableViewController
@synthesize inDisplay = _inDisplay;
@synthesize minLoadingTime = _minLoadingTime;
@synthesize controllerView = _controllerView;
- (instancetype)initWithStyle:(UITableViewStyle)style {
        if (self = [super initWithNibName:nil bundle:nil]) {
                [self didInitializedWithStyle:style];
        }
        return self;
}

- (instancetype)init {
        return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
        return [self init];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
        if (self = [super initWithCoder:aDecoder]) {
                [self didInitializedWithStyle:UITableViewStylePlain];
        }
        return self;
}

- (void)didInitializedWithStyle:(UITableViewStyle)style {
        _style = style;
        if ([self respondsToSelector:@selector(setTransitioningDelegate:)])
        {
                self.transitioningDelegate     = [MLSTransition shared];
                self.allowsArbitraryPresenting = YES;
        }
        self.minLoadingTime = 0.2;
        self.hasHideTableHeaderViewInitial = NO;
        self.tableViewInitialContentInset = BaseCommonTableViewControllerInitialContentInsetNotSet;
        self.tableViewInitialScrollIndicatorInsets = BaseCommonTableViewControllerInitialContentInsetNotSet;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.privateDelegate = [[BaseTableViewDelegate alloc] initWithReceiver:self];
}

- (void)loadView
{
        _controllerView = [[self class] controllerView];
        if (!_controllerView)
        {
                UIView *view = [(UIView *) [[self __viewClass] alloc] initWithFrame:[UIScreen mainScreen].bounds];
                NSAssert([view conformsToProtocol:@protocol(BaseTableControllerViewProtocol)], @"%@ controller view is not conforms To Protocol BaseControllerViewProtocol",[self class]);
                _controllerView = (UIView <BaseTableControllerViewProtocol> *)view;
        }
        NSAssert(_controllerView != nil, @"can't find view for controller: %@", [self class]);
        if (!_controllerView)
        {
                _controllerView = [[BaseTableControllerView alloc] init];
        }
        
        self.view = _controllerView;
}

- (Class)__viewClass
{
        Class    controllerClass = [self class];
        NSString *viewClassName  = [NSStringFromClass(controllerClass) stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
        Class    viewClass       = NSClassFromString(viewClassName);
        
        /// 找父类的 Controller 的 View
        while (!viewClass) {
                controllerClass = class_getSuperclass(controllerClass);
                if (controllerClass == [BaseViewController class]) {
                        return [BaseControllerView class];
                }
                
                viewClassName = [NSStringFromClass(controllerClass) stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
                viewClass     = NSClassFromString(viewClassName);
        }
        return viewClass;
}

- (void)initSubviews
{
        [self initTableView];
        if ([self.controllerView respondsToSelector:@selector(setTableView:)])
        {
                [self.controllerView setTableView:self.tableView];
        }
        
        [super initSubviews];
}

- (void)configNimbus
{
        self.tableViewActions = [[NITableViewActions alloc] initWithTarget:self];
        self.tableViewActions.tableViewCellSelectionStyle = UITableViewCellSelectionStyleNone;
        [self.tableViewActions forwardingTo:self.privateDelegate];
        
        self.cellFactory = [[NICellFactory alloc] init];
        self.tableViewModel = [[NIMutableTableViewModel alloc] initWithDelegate:self];
        
        if ([self.controllerView respondsToSelector:@selector(setTableViewModel:)])
        {
                [self.controllerView setTableViewModel:self.tableViewModel];
        }
        if ([self.controllerView respondsToSelector:@selector(setTableViewActions:)])
        {
                [self.controllerView setTableViewActions:self.tableViewActions];
        }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return [self.cellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.tableViewModel];
}
- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
        return [self.cellFactory tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
}
/// MARK: - QMUIKit
- (void)dealloc
{
        // 用下划线而不是self.xxx来访问tableView，避免dealloc时self.view尚未被加载，此时调用self.tableView反而会触发loadView
        _tableView.delegate = nil;
        _tableView.dataSource = nil;
        _tableViewModel = nil;
        _tableViewActions = nil;
        _cellFactory = nil;
//#if DEBUG
//        [MLSTipClass showText:[NSString stringWithFormat:@"------ %@ ------- dealloc",[self className]]];
//#endif
        NSLogDebug(@"-------%@ dealloc -------",self);
}

- (NSString *)description {
        if (![self isViewLoaded]) {
                return [super description];
        }
        
        NSString *result = [NSString stringWithFormat:@"%@\ntableView:\t\t\t\t%@", [super description], self.tableView];
        NSInteger sections = [self.tableView.dataSource numberOfSectionsInTableView:self.tableView];
        if (sections > 0) {
                NSMutableString *sectionCountString = [[NSMutableString alloc] init];
                [sectionCountString appendFormat:@"\ndataCount(%@):\t\t\t\t(\n", @(sections)];
                NSInteger sections = [self.tableView.dataSource numberOfSectionsInTableView:self.tableView];
                for (NSInteger i = 0; i < sections; i++) {
                        NSInteger rows = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:i];
                        [sectionCountString appendFormat:@"\t\t\t\t\t\t\tsection%@ - rows%@%@\n", @(i), @(rows), i < sections - 1 ? @"," : @""];
                }
                [sectionCountString appendString:@"\t\t\t\t\t\t)"];
                result = [result stringByAppendingString:sectionCountString];
        }
        return result;
}

- (void)viewDidLayoutSubviews {
        [super viewDidLayoutSubviews];
        
        if ([self shouldAdjustTableViewContentInsetsInitially] && !self.hasSetInitialContentInset)
        {
                self.tableView.contentInset = self.tableViewInitialContentInset;
                if ([self shouldAdjustTableViewScrollIndicatorInsetsInitially]) {
                        self.tableView.scrollIndicatorInsets = self.tableViewInitialScrollIndicatorInsets;
                } else {
                        // 默认和tableView.contentInset一致
                        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
                }
                [self.tableView qmui_scrollToTop];
                self.hasSetInitialContentInset = YES;
        }
        
        [self hideTableHeaderViewInitialIfCanWithAnimated:NO force:NO];
        
        [self layoutEmptyView];
}


#pragma mark - 工具方法
- (QMUITableView *)tableView {
        if (!_tableView) {
                [self loadViewIfNeeded];
        }
        return _tableView;
}

- (void)hideTableHeaderViewInitialIfCanWithAnimated:(BOOL)animated force:(BOOL)force {
        if (self.tableView.tableHeaderView && [self shouldHideTableHeaderViewInitial] && (force || !self.hasHideTableHeaderViewInitial)) {
                CGPoint contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.tableHeaderView.frame));
                [self.tableView setContentOffset:contentOffset animated:animated];
                self.hasHideTableHeaderViewInitial = YES;
        }
}

- (void)contentSizeCategoryDidChanged:(NSNotification *)notification {
        [super contentSizeCategoryDidChanged:notification];
        [self.tableView reloadData];
}

- (void)setTableViewInitialContentInset:(UIEdgeInsets)tableViewInitialContentInset {
        _tableViewInitialContentInset = tableViewInitialContentInset;
        if (UIEdgeInsetsEqualToEdgeInsets(tableViewInitialContentInset, BaseCommonTableViewControllerInitialContentInsetNotSet))
        {
                 self.automaticallyAdjustsScrollViewInsets = YES;
        }
        else
        {
                 self.automaticallyAdjustsScrollViewInsets = NO;
        }
}

- (BOOL)shouldAdjustTableViewContentInsetsInitially {
        BOOL shouldAdjust = !UIEdgeInsetsEqualToEdgeInsets(self.tableViewInitialContentInset, BaseCommonTableViewControllerInitialContentInsetNotSet);
        return shouldAdjust;
}

- (BOOL)shouldAdjustTableViewScrollIndicatorInsetsInitially {
        BOOL shouldAdjust = !UIEdgeInsetsEqualToEdgeInsets(self.tableViewInitialScrollIndicatorInsets, BaseCommonTableViewControllerInitialContentInsetNotSet);
        return shouldAdjust;
}

@end


@implementation BaseTableViewController (BaseSubclassingHooks)

- (void)initTableView {
        if (!_tableView) {
                _tableView = [[BaseTableView alloc] initWithFrame:self.view.bounds style:self.style];
                if (@available(iOS 11.0, *)) {
                        if (self.automaticallyAdjustsScrollViewInsets == YES)
                        {
                                self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
                        }
                        else
                        {
                                self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                        }
                }
        }
}

- (BOOL)shouldHideTableHeaderViewInitial {
        return NO;
}

@end
