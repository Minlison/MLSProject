//
//  MLSCommentView.m
//  MinLison
//
//  Created by minlison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSCommentView.h"
#import "MLSCommentHeaderView.h"
#import "MLSCommentTableViewCell.h"
#import "MLSEmptyCommentTableViewCell.h"
#import "MLSSendCommentRequest.h"
@interface MLSCommentView()
@property(nonatomic, copy) WGCommentActionBlock actionBlock;
@property(nonatomic, strong) NSMutableDictionary *commentCountDict;
@end
@implementation MLSCommentView

- (void)setCommentCount:(NSUInteger)count type:(WGCommentListType)type
{
        [self.commentCountDict setObject:@(count) forKey:@(type)];
}
- (void)addCommentCount:(NSUInteger)count type:(WGCommentListType)type
{
        [self.commentCountDict setObject:@([self.commentCountDict jk_integerForKey:@(type)] + count) forKey:@(type)];
}
- (void)setupTableView
{
        [super setupTableView];
        self.commentCountDict = [NSMutableDictionary dictionaryWithCapacity:2];
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        [self.tableView registerClass:[MLSCommentHeaderView class] forHeaderFooterViewReuseIdentifier:[MLSCommentHeaderView className]];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        MLSCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MLSCommentHeaderView className]];
        // 覆盖文字
        if (section == 0)
        {
                header.text = [NSString aPP_WonderfulComment];
        }
        else
        {
                header.text = [NSString aPP_NewestCommentValue1:(int)[self.commentCountDict jk_integerForKey:@(WGCommentListTypeNormal)]];
        }
        return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return [tableView fd_heightForHeaderFooterViewWithIdentifier:[MLSCommentHeaderView className] configuration:^(MLSCommentHeaderView * headerFooterView) {
                if (section == 0)
                {
                        headerFooterView.text = [NSString aPP_WonderfulComment];
                }
                else
                {
                        headerFooterView.text = [NSString aPP_NewestCommentValue1:(int)[self.commentCountDict jk_integerForKey:@(WGCommentListTypeNormal)]];
                }
        }];
}
@end
