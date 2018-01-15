//
//  MLSUserFormButtonCell.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUserFormButtonCell.h"
@interface MLSUserFormButtonCell ()
@property(nonatomic, strong, readwrite) QMUIGhostButton *button;
@end
@implementation MLSUserFormButtonCell

+ (CGFloat)heightForField:(FXFormField *)field width:(CGFloat)width
{
        return 100;
}
- (void)didSelectWithTableView:(UITableView *)tableView controller:(UIViewController *)controller
{
        // do nothing
}
- (void)setUp
{
        //override
        [self.contentView addSubview:self.button];
        
        [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(__WGWidth(34));
                make.right.equalTo(self.contentView).offset(-__WGWidth(28));
                CGFloat height = [[self class] heightForField:self.field width:0];
                if ([CoBaseUtils isPhoneType:(iPhoneTypeInches_5_5)] || [CoBaseUtils isPhoneType:(iPhoneTypeInches_5_8)])
                {
                        make.height.mas_equalTo(__WGHeight(MIN(height, 44)));
                }
                else
                {
                        make.height.mas_equalTo(__WGHeight(MIN(height, 48)));
                }
        }];
        @weakify(self);
        [self.button jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (self.field.action) {
                        self.field.action(self);
                }
        }];
        
}
- (void)update
{
//        [super update];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.button setTitle:self.field.title forState:(UIControlStateNormal)];
}

- (QMUIGhostButton *)button
{
        if (_button == nil) {
                _button = [[QMUIGhostButton alloc] init];
                _button.ghostColor = UIColorClear;
                _button.cornerRadius = 5;
                [_button setTitleColor:UIColorWhite forState:(UIControlStateNormal)];
                [_button setTitle:[NSString app_Login] forState:(UIControlStateNormal)];
                _button.backgroundColor = UIColorHex(0x80C8EA);
        }
        return _button;
}

@end
