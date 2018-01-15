//
//  BaseTableView.m
//  MinLison
//
//  Created by MinLison on 2017/10/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTableView.h"
#import "BaseTableViewDelegate.h"
#import "BaseTableViewDataSource.h"

@interface BaseTableView ()
@property(nonatomic, strong) WZProtocolInterceptor <QMUITableViewDelegate> *delegateProxy;
@property(nonatomic, strong) WZProtocolInterceptor <QMUITableViewDataSource> *dataSourceProxy;
@property(nonatomic, strong) BaseTableViewDelegate *privateDelegate;
@property(nonatomic, strong) BaseTableViewDataSource *privateDatasource;
@end
@implementation BaseTableView
@synthesize autoAdjustView = _autoAdjustView;
- (void)didInitialized
{
        [super didInitialized];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = UIColorWhite;
        [self.KVOController observe:self keyPath:@keypath(self,contentOffset) options:(NSKeyValueObservingOptionNew) block:^(BaseTableView *  _Nullable observer, BaseTableView *  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                [object adjustHeaderView];
        }];
#ifdef DEBUG
        self.fd_debugLogEnabled = YES;
#endif
}
- (void)setDelegate:(id<QMUITableViewDelegate>)delegate
{
        if (delegate == (id<QMUITableViewDelegate>)self || delegate == nil || [delegate isKindOfClass:[NITableViewActions class]])
        {
                self.delegateProxy = nil;
                self.privateDelegate = nil;
                [super setDelegate:delegate];
                return;
        }
        self.privateDelegate = [[BaseTableViewDelegate alloc] initWithReceiver:delegate];
        self.delegateProxy = (WZProtocolInterceptor <QMUITableViewDelegate> *)[[WZProtocolInterceptor alloc] initWithInterceptedProtocol:@protocol(QMUITableViewDelegate)];
        self.delegateProxy.receiver = delegate;
        self.delegateProxy.middleMan = self.privateDelegate;
        [super setDelegate:self.delegateProxy];
}
- (void)setDataSource:(id<QMUITableViewDataSource>)dataSource
{
        if (dataSource == (id<QMUITableViewDataSource>)self || dataSource == nil || [dataSource isKindOfClass:[NITableViewModel class]])
        {
                self.dataSourceProxy = nil;
                self.privateDatasource = nil;
                [super setDataSource:dataSource];
                return;
        }
        self.privateDatasource = [[BaseTableViewDataSource alloc] initWithReceiver:dataSource];
        self.dataSourceProxy = (WZProtocolInterceptor <QMUITableViewDataSource> *)[[WZProtocolInterceptor alloc] initWithInterceptedProtocol:@protocol(QMUITableViewDataSource)];
        self.dataSourceProxy.receiver = dataSource;
        self.dataSourceProxy.middleMan = self.privateDatasource;
        [super setDataSource:self.dataSourceProxy];
}
- (void)adjustHeaderView
{
        if (!self.enableAutoAdjustHeader || !self.autoAdjustView)
        {
                return;
        }
        CGFloat y = self.contentOffset.y;

        if (y <= 0)
        {
                CGFloat height = CGRectGetHeight(self.tableHeaderView.bounds);
                CGFloat scale = 1 - y / height;
                CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0.50000 * y);
                transform = CGAffineTransformScale(transform, scale, scale);
                self.autoAdjustView.transform = transform;
        }
        else
        {
                self.autoAdjustView.transform = CGAffineTransformIdentity;
        }
}
- (void)setAutoAdjustView:(UIView *)autoAdjustView
{
        _autoAdjustView = autoAdjustView;
        self.enableAutoAdjustHeader = (autoAdjustView != nil);
}
- (UIView *)autoAdjustView
{
        if (!_autoAdjustView) {
                _autoAdjustView = [self.tableHeaderView sameBoundsSubView];
        }
        return _autoAdjustView;
}


@end
