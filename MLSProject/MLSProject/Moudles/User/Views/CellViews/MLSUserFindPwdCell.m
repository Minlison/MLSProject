//
//  MLSUserFindPwdCell.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUserFindPwdCell.h"

@interface MLSUserFindPwdCell ()
@property(nonatomic, strong) QMUIButton *findPwdButton;
@end

@implementation MLSUserFindPwdCell

+ (CGFloat)heightForField:(FXFormField *)field width:(CGFloat)width
{
        return __WGHeight(30);
}

- (void)setUp
{
        [super setUp];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.findPwdButton];
        [self.findPwdButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView).offset(-UserFormRightMargin);
        }];
}
- (QMUIButton *)findPwdButton
{
        if (_findPwdButton == nil) {
                _findPwdButton = [[QMUIButton alloc] init];
                [_findPwdButton setTitle:@"找回密码" forState:(UIControlStateNormal)];
                [_findPwdButton setTitleColor:UIColorHex(0x969696) forState:(UIControlStateNormal)];
                _findPwdButton.titleLabel.font = WGSystem14Font;
                @weakify(self);
                [_findPwdButton jk_addActionHandler:^(NSInteger tag) {
                        @strongify(self);
                        if (self.field.action)
                        {
                                self.field.action(self);
                        }
                }];
        }
        return _findPwdButton;
}
@end
