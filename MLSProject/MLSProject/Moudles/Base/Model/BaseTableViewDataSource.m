//
//  WGTableViewDataSource.m
//  MinLison
//
//  Created by MinLison on 2017/11/7.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTableViewDataSource.h"

@interface BaseTableViewDataSource()
@end

@implementation BaseTableViewDataSource

- (id)forwardingTargetForSelector:(SEL)aSelector
{
        if ([self.receiver respondsToSelector:aSelector]) {
                return self.receiver;
        }
        return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
        if ([self.receiver respondsToSelector:aSelector]) {
                return YES;
        }
        return [super respondsToSelector:aSelector];
}

- (instancetype)init
{
        return [self initWithReceiver:nil];
}
- (instancetype)initWithReceiver:(nullable id<QMUITableViewDataSource>)receiver
{
        if (self = [super init])
        {
                self.receiver = receiver;
        }
        return self;
}

#pragma mark - <QMUITableViewDelegate, QMUITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        if ([self.receiver respondsToSelector:_cmd]) {
                return [self.receiver numberOfSectionsInTableView:tableView];
        }
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        if ([self.receiver respondsToSelector:_cmd]) {
                return [self.receiver tableView:tableView numberOfRowsInSection:section];
        }
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if ([self.receiver respondsToSelector:_cmd]) {
                return [self.receiver tableView:tableView cellForRowAtIndexPath:indexPath];
        }
        return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
        return nil;
}
@end
