//
//  MLSFeedBackCommentContentCell.m
//  MinLison
//
//  Created by MinLison on 2017/11/20.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSFeedBackCommentContentCell.h"
#import "MLSFeedBackCommentContentModel.h"
@implementation MLSFeedBackCommentContentCell
- (BOOL)shouldUpdateCellWithObject:(MLSFeedBackCommentContentModel *)object
{
        if ( ![object isKindOfClass:[MLSFeedBackCommentContentModel class]] ) {
                return NO;
        }
        [self updateContentWithObj:object];
        return YES;
}
+ (CGFloat)heightForObject:(MLSFeedBackCommentContentModel *)object identifier:(NSString *)identifier atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
        return tableView.height - [tableView rectForHeaderInSection:1].size.height;
}
- (void)updateContentWithObj:(MLSFeedBackCommentContentModel *)obj
{
        if ([self.contentView.subviews containsObject:obj.commentContentView])
        {
                return;
        }
        [self.contentView addSubview:obj.commentContentView];
        [obj.commentContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
        }];
}
@end
