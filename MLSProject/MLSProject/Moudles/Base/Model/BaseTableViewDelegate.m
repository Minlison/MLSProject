//
//  BaseTableViewDelegate.m
//  MinLison
//
//  Created by MinLison on 2017/11/7.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTableViewDelegate.h"
const NSInteger kBaseSectionHeaderFooterLabelTag = 1024;

@interface BaseTableViewDelegate ()
@end

@implementation BaseTableViewDelegate

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
- (instancetype)initWithReceiver:(nullable id<QMUITableViewDelegate>)receiver
{
        if (self = [super init])
        {
                self.receiver = receiver;
        }
        return self;
}
// 默认拿title来构建一个view然后添加到viewForHeaderInSection里面，如果业务重写了viewForHeaderInSection，则titleForHeaderInSection被覆盖
// viewForFooterInSection同上
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        if ([self.receiver respondsToSelector:_cmd])
        {
                return [self.receiver tableView:tableView viewForHeaderInSection:section];
        }
        NSString *title = [self tableView:tableView realTitleForHeaderInSection:section];
        if (title) {
                UITableViewHeaderFooterView *headerFooterView = [self tableHeaderFooterLabelInTableView:tableView identifier:@"headerTitle"];
                QMUILabel *label = (QMUILabel *)[headerFooterView.contentView viewWithTag:kBaseSectionHeaderFooterLabelTag];
                label.text = title;
                label.contentEdgeInsets = tableView.style == UITableViewStylePlain ? TableViewSectionHeaderContentInset : TableViewGroupedSectionHeaderContentInset;
                label.font = tableView.style == UITableViewStylePlain ? TableViewSectionHeaderFont : TableViewGroupedSectionHeaderFont;
                label.textColor = tableView.style == UITableViewStylePlain ? TableViewSectionHeaderTextColor : TableViewGroupedSectionHeaderTextColor;
                label.backgroundColor = tableView.style == UITableViewStylePlain ? TableViewSectionHeaderBackgroundColor : UIColorClear;
                CGFloat labelLimitWidth = CGRectGetWidth(tableView.bounds) - UIEdgeInsetsGetHorizontalValue(tableView.contentInset);
                CGSize labelSize = [label sizeThatFits:CGSizeMake(labelLimitWidth, CGFLOAT_MAX)];
                label.frame = CGRectMake(0, 0, labelLimitWidth, labelSize.height);
                return label;
        }
        return [self tableHeaderFooterTableView:tableView identifier:@"EmptyHeaderFooter"];
}

// 同viewForHeaderInSection
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
        if ([self.receiver respondsToSelector:_cmd])
        {
                return [self.receiver tableView:tableView viewForFooterInSection:section];
        }
        NSString *title = [self tableView:tableView realTitleForFooterInSection:section];
        if (title) {
                UITableViewHeaderFooterView *headerFooterView = [self tableHeaderFooterLabelInTableView:tableView identifier:@"footerTitle"];
                QMUILabel *label = (QMUILabel *)[headerFooterView.contentView viewWithTag:kBaseSectionHeaderFooterLabelTag];
                label.text = title;
                label.contentEdgeInsets = tableView.style == UITableViewStylePlain ? TableViewSectionFooterContentInset : TableViewGroupedSectionFooterContentInset;
                label.font = tableView.style == UITableViewStylePlain ? TableViewSectionFooterFont : TableViewGroupedSectionFooterFont;
                label.textColor = tableView.style == UITableViewStylePlain ? TableViewSectionFooterTextColor : TableViewGroupedSectionFooterTextColor;
                label.backgroundColor = tableView.style == UITableViewStylePlain ? TableViewSectionFooterBackgroundColor : UIColorClear;
                CGFloat labelLimitWidth = CGRectGetWidth(tableView.bounds) - UIEdgeInsetsGetHorizontalValue(tableView.contentInset);
                CGSize labelSize = [label sizeThatFits:CGSizeMake(labelLimitWidth, CGFLOAT_MAX)];
                label.frame = CGRectMake(0, 0, labelLimitWidth, labelSize.height);
                return label;
        }
        return [self tableHeaderFooterTableView:tableView identifier:@"EmptyHeaderFooter"];
}

- (UITableViewHeaderFooterView *)tableHeaderFooterLabelInTableView:(UITableView *)tableView identifier:(NSString *)identifier {
        
        UITableViewHeaderFooterView *headerFooterView = [self tableHeaderFooterTableView:tableView identifier:identifier];
        QMUILabel *label = [[QMUILabel alloc] init];
        label.tag = kBaseSectionHeaderFooterLabelTag;
        label.numberOfLines = 0;
        [headerFooterView.contentView addSubview:label];
        return headerFooterView;
}

- (UITableViewHeaderFooterView *)tableHeaderFooterTableView:(UITableView *)tableView identifier:(NSString *)identifier {
        
        UITableViewHeaderFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (!headerFooterView) {
                headerFooterView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
                headerFooterView.contentView.backgroundColor = tableView.backgroundColor;
        }
        return headerFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        if ([self.receiver respondsToSelector:_cmd])
        {
                return [self.receiver tableView:tableView heightForHeaderInSection:section];
        }
        // 分别测试过 iOS 11 前后的系统版本，最终总结，对于 Plain 类型的 tableView 而言，要去掉 header / footer 请使用 0，对于 Grouped 类型的 tableView 而言，要去掉 header / footer 请使用 CGFLOAT_MIN
        return tableView.style == UITableViewStylePlain ? 0.001 : TableViewGroupedSectionHeaderDefaultHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
        if ([self.receiver respondsToSelector:_cmd])
        {
                return [self.receiver tableView:tableView heightForFooterInSection:section];
        }
        // 分别测试过 iOS 11 前后的系统版本，最终总结，对于 Plain 类型的 tableView 而言，要去掉 header / footer 请使用 0，对于 Grouped 类型的 tableView 而言，要去掉 header / footer 请使用 CGFLOAT_MIN
        return tableView.style == UITableViewStylePlain ? 0.001 : TableViewGroupedSectionFooterDefaultHeight;
}

// 是否有定义某个section的header title
- (NSString *)tableView:(UITableView *)tableView realTitleForHeaderInSection:(NSInteger)section {
        if ([tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
                NSString *sectionTitle = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
                if (sectionTitle && sectionTitle.length > 0) {
                        return sectionTitle;
                }
        }
        return nil;
}

// 是否有定义某个section的footer title
- (NSString *)tableView:(UITableView *)tableView realTitleForFooterInSection:(NSInteger)section {
        if ([tableView.dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
                NSString *sectionFooter = [tableView.dataSource tableView:tableView titleForFooterInSection:section];
                if (sectionFooter && sectionFooter.length > 0) {
                        return sectionFooter;
                }
        }
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if ([self.receiver respondsToSelector:_cmd])
        {
                return [self.receiver tableView:tableView heightForRowAtIndexPath:indexPath];
        }
        return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
        if ([self.receiver respondsToSelector:_cmd])
        {
                return [self.receiver tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
        }
        return UITableViewAutomaticDimension;
}
@end
