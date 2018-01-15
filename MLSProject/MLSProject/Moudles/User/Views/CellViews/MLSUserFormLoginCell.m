//
//  MLSUserFormLoginCell.m
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserFormLoginCell.h"
#import "MZTimerLabel.h"

const CGFloat UserFormBootomLineHeight = 0.5;
const CGFloat UserFormLeftMargin = 31;
const CGFloat UserFormRightMargin = 31;
const UIEdgeInsets UserFormTextFieldInsets = {0, -8, 0, -3}; // top, left, bottom, right
const CGSize UserFormleftViewSize = {0,30};
const CGSize UserFormrightViewSize = {76,50};

@interface MLSUserFormLoginCell ()
@property(nonatomic, strong, readwrite) QMUIButton *leftView;
@property(nonatomic, strong, readwrite) UIView *lineView;
@end

@implementation MLSUserFormLoginCell
+ (CGFloat)heightForField:(FXFormField *)field width:(CGFloat)width
{
        return __WGWidth(60);
}

- (BOOL)autoAction
{
        return NO;
}
- (void)setUp
{
        [super setUp];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
        self.textField.font = WGSystem16Font;
        self.textField.placeholderFont = WGSystem16Font;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self.textField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFielDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self.textField];
}
- (void)textFielDidEndEditing:(NSNotification *)noti
{
        self.lineView.backgroundColor = UIColorHex(0xdce1eb);
        self.leftView.selected = NO;
}
- (void)textFieldDidBeginEditing:(NSNotification *)noti
{
        self.lineView.backgroundColor = UIColorHex(0xdce1eb);
        self.leftView.selected = YES;
}
- (void)setShowBootomLine:(BOOL)showBootomLine
{
        if (_showBootomLine != showBootomLine) {
                _showBootomLine = showBootomLine;
                self.lineView.hidden = !showBootomLine;
        }
}

- (void)setLeftViewImg:(UIImage *)leftViewImg
{
        [self.leftView setImage:leftViewImg forState:(UIControlStateNormal)];
}
- (void)setPlaceHolder:(NSString *)placeHolder
{
        self.textField.placeholder = placeHolder;
}
- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
        self.textField.keyboardType = keyboardType;
}
- (void)setupView
{
        [self.contentView addSubview:self.leftView];
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UIColorHex(0xdce1eb);
        self.textField.placeholderColor = UIColorHex(0xCAD1E0);
        self.textField.placeholderFont = WGSystem14Font;
        self.textField.textColor = UIColorHex(0x3b3b3b);
        self.textField.font = WGSystem16Font;
        [self.contentView addSubview:self.lineView];
}
- (void)update
{
        [super update];
        [self layout];
}
- (void)layout
{
        [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(__WGWidth(UserFormLeftMargin));
                make.size.mas_equalTo(CGSizeMake(__WGWidth(UserFormleftViewSize.width), __WGHeight(UserFormleftViewSize.height)));
                make.bottom.equalTo(self.contentView);
        }];
        
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftView.mas_right).offset(__WGWidth(UserFormTextFieldInsets.left));
                make.right.equalTo(self.contentView.mas_right).offset(-__WGWidth(UserFormRightMargin));
                make.centerY.equalTo(self.leftView);
                make.top.greaterThanOrEqualTo(self.contentView).offset(__WGWidth(UserFormTextFieldInsets.top));
                make.bottom.lessThanOrEqualTo(self.contentView).offset(-__WGWidth(UserFormTextFieldInsets.bottom));
        }];
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftView.imageView.mas_left);
                make.right.equalTo(self.textField.mas_right);
                make.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(__WGWidth(UserFormBootomLineHeight));
        }];
}
- (QMUIButton *)leftView
{
        if (_leftView == nil) {
                _leftView = [[QMUIButton alloc] initWithFrame:CGRectZero];
                _leftView.contentMode = UIViewContentModeLeft;
        }
        return _leftView;
}
- (BOOL)shouldLayoutSubviews
{
        return NO;
}

- (void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
