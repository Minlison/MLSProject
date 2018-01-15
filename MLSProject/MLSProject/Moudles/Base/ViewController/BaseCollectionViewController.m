//
//  BaseCollectionViewController.m
//  MLSProject
//
//  Created by MinLison on 2017/12/1.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "BaseCollectionControllerView.h"

const UIEdgeInsets BaseCommonCollectionViewControllerInitialContentInsetNotSet = {-1, -1, -1, -1};

@interface BaseCollectionViewController ()
@end

@implementation BaseCollectionViewController
@synthesize controllerView = _controllerView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
        return [self initWithCollectionViewLayout:nil];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
        return [self initWithCollectionViewLayout:nil];
}
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
        if (self = [super initWithNibName:nil bundle:nil])
        {
                [self didInitializedWithLayout:layout ?:[self createFlowLayout]];
        }
        return self;
}
- (UICollectionViewFlowLayout *)createFlowLayout
{
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(80, 80);
        flowLayout.minimumLineSpacing = 8;
        flowLayout.minimumInteritemSpacing = 8;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.headerReferenceSize = CGSizeZero;
        flowLayout.footerReferenceSize = CGSizeZero;
        self.layout = flowLayout;
        return flowLayout;
}
- (void)didInitializedWithLayout:(UICollectionViewLayout *)layout
{
        self.layout = layout;
        if ([self respondsToSelector:@selector(setTransitioningDelegate:)])
        {
                self.transitioningDelegate     = [MLSTransition shared];
                self.allowsArbitraryPresenting = YES;
        }
}
- (void)loadView
{
        _controllerView = [[self class] controllerView];
        if (!_controllerView)
        {
                UIView *view = [(UIView *) [[self __viewClass] alloc] initWithFrame:[UIScreen mainScreen].bounds];
                NSAssert([view conformsToProtocol:@protocol(BaseCollectionControllerViewProtocol)], @"%@ controller view is not conforms To Protocol BaseControllerViewProtocol",[self class]);
                _controllerView = (UIView <BaseCollectionControllerViewProtocol> *)view;
        }
        NSAssert(_controllerView != nil, @"can't find view for controller: %@", [self class]);
        if (!_controllerView)
        {
                _controllerView = [[BaseCollectionControllerView alloc] init];
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
        [self initCollectionView];
        if ([self.controllerView respondsToSelector:@selector(setCollectionView:)])
        {
                [self.controllerView setCollectionView:self.collectionView];
        }
        
        [super initSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)configNimbus
{
        self.collectionViewActions = [[NICollectionViewActions alloc] initWithTarget:self];
        [self.collectionViewActions forwardingTo:self];
        
        self.cellFactory = [[NICollectionViewCellFactory alloc] init];
        self.collectionViewModel = [[NIMutableCollectionViewModel alloc] initWithDelegate:self];
        
        self.collectionView.delegate = self.collectionViewActions;
        self.collectionView.dataSource = self.collectionViewModel;
        
        if ([self.controllerView respondsToSelector:@selector(setCollectionViewModel:)])
        {
                [self.controllerView setCollectionViewModel:self.collectionViewModel];
        }
        if ([self.controllerView respondsToSelector:@selector(setCollectionViewActions:)])
        {
                [self.controllerView setCollectionViewActions:self.collectionViewActions];
        }
        
}

- (UICollectionViewCell *)collectionViewModel:(NICollectionViewModel *)collectionViewModel cellForCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
        return [self.cellFactory collectionViewModel:collectionViewModel cellForCollectionView:collectionView atIndexPath:indexPath withObject:object];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        return [self.cellFactory collectionView:collectionView sizeForItemAtIndexPath:indexPath model:self.collectionViewModel];
}

- (void)dealloc
{
        _collectionView.delegate = nil;
        _collectionView.dataSource = nil;
        _collectionViewModel = nil;
        _collectionViewActions = nil;
        _cellFactory = nil;
        NSLogDebug(@"-------%@ dealloc -------",self);
}

- (NSString *)description {
        if (![self isViewLoaded]) {
                return [super description];
        }
        
        NSString *result = [NSString stringWithFormat:@"%@\ncollectionView:\t\t\t\t%@", [super description], self.collectionView];
        NSInteger sections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
        if (sections > 0) {
                NSMutableString *sectionCountString = [[NSMutableString alloc] init];
                [sectionCountString appendFormat:@"\ndataCount(%@):\t\t\t\t(\n", @(sections)];
                NSInteger sections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
                for (NSInteger i = 0; i < sections; i++) {
                        NSInteger rows = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:i];
                        [sectionCountString appendFormat:@"\t\t\t\t\t\t\tsection%@ - rows%@%@\n", @(i), @(rows), i < sections - 1 ? @"," : @""];
                }
                [sectionCountString appendString:@"\t\t\t\t\t\t)"];
                result = [result stringByAppendingString:sectionCountString];
        }
        return result;
}

- (void)viewDidLayoutSubviews {
        [super viewDidLayoutSubviews];
        [self layoutEmptyView];
}

#pragma mark - 工具方法
- (BaseCollectionView *)collectionView {
        if (!_collectionView) {
                [self loadViewIfNeeded];
        }
        return _collectionView;
}


- (void)contentSizeCategoryDidChanged:(NSNotification *)notification {
        [super contentSizeCategoryDidChanged:notification];
        [self.collectionView reloadData];
}
- (void)setCollectionViewInitialContentInset:(UIEdgeInsets)collectionViewInitialContentInset
{
        _collectionViewInitialContentInset = collectionViewInitialContentInset;
        if (UIEdgeInsetsEqualToEdgeInsets(collectionViewInitialContentInset, BaseCommonCollectionViewControllerInitialContentInsetNotSet))
        {
                self.automaticallyAdjustsScrollViewInsets = YES;
        }
        else
        {
                self.automaticallyAdjustsScrollViewInsets = NO;
        }
}
- (void)setTableViewInitialContentInset:(UIEdgeInsets)tableViewInitialContentInset {
       
}

- (BOOL)shouldAdjustTableViewContentInsetsInitially {
        BOOL shouldAdjust = !UIEdgeInsetsEqualToEdgeInsets(self.collectionViewInitialContentInset, BaseCommonCollectionViewControllerInitialContentInsetNotSet);
        return shouldAdjust;
}

- (BOOL)shouldAdjustTableViewScrollIndicatorInsetsInitially {
        BOOL shouldAdjust = !UIEdgeInsetsEqualToEdgeInsets(self.collectionViewInitialContentInset, BaseCommonCollectionViewControllerInitialContentInsetNotSet);
        return shouldAdjust;
}


@end

@implementation BaseCollectionViewController (BaseSubclassingHooks)
- (void)initCollectionView
{
        if (!_collectionView) {
                _collectionView = [[BaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
                _collectionView.backgroundColor = self.view.backgroundColor;
//                _collectionView.pagingEnabled = YES;
                if (@available(iOS 11.0, *))
                {
                        if (self.automaticallyAdjustsScrollViewInsets == YES)
                        {
                                self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
                        }
                        else
                        {
                                self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                        }
                }
        }
}
@end
