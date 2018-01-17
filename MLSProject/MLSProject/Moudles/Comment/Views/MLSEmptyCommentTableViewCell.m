//
//  MLSEmptyCommentTableViewCell.m
//  MinLison
//
//  Created by minlison on 2017/10/30.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSEmptyCommentTableViewCell.h"
#import "MLSEmptyCommentModel.h"

@interface MLSEmptyCommentTableViewCell()
@property (strong, nonatomic)  UILabel *contentLabel;
@end
@implementation MLSEmptyCommentTableViewCell
- (BOOL)shouldUpdateCellWithObject:(MLSEmptyCommentModel *)object
{
        if ([object isKindOfClass:[MLSEmptyCommentModel class]]) {
                self.contentLabel.text = object.emptyContent;
        }
        return NO;
}
+ (CGFloat)heightForObject:(id)object identifier:(NSString *)identifier atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
        return UITableViewAutomaticDimension;
}
- (void)setupView
{
        [super setupView];
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.font = WGSystem15Font;
        self.contentLabel.textColor = UIColorHex(0x999999);
        [self.contentView addSubview:self.contentLabel];
        
        UIView *leftLine = [[UIView alloc]init];
        leftLine.backgroundColor = UIColorHex(0xE1E1E1);
        [self.contentView addSubview:leftLine];
        
        UIView *rightLine = [[UIView alloc]init];
        rightLine.backgroundColor = UIColorHex(0xE1E1E1);
        [self.contentView addSubview:rightLine];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(__WGHeight(10));
                make.bottom.equalTo(self.contentView).offset(-__WGHeight(30));
                make.centerX.equalTo(self.contentView);
        }];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(__WGWidth(16.0f));
                make.height.mas_equalTo(__WGWidth(1.0f));
                make.centerY.equalTo(self.contentLabel.mas_centerY);
                make.trailing.equalTo(self.contentLabel.mas_leading).offset(-__WGWidth(3.0f));
        }];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(__WGWidth(16.0f));
                make.height.mas_equalTo(__WGWidth(1.0f));
                make.centerY.equalTo(self.contentLabel.mas_centerY);
                make.leading.equalTo(self.contentLabel.mas_trailing).offset(__WGWidth(3.0f));
        }];
}

@end
