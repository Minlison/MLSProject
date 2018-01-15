//
//  BaseTableViewCell.m
//  MinLison
//
//  Created by MinLison on 2017/10/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
        if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
        {
                self.selectionStyle = UITableViewCellSelectionStyleNone;
                self.contentView.clipsToBounds = YES;
                self.clipsToBounds = YES;
                [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self);
                }];
                [self setupView];
        }
        return self;
}

- (void)setupView
{
        
}

@end
