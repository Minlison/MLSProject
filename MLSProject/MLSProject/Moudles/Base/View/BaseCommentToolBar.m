//
//  BaseCommentToolBar.m
//  MinLison
//
//  Created by MinLison on 2017/11/7.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseCommentToolBar.h"
#define KCommentToolBarSendBtnWidth             34
#define KCommentToolBarTopMargin                8
#define KCommentToolBarBottomMargin             8
#define KCommentToolBarLeftMargin               15
#define KCommentToolBarRightMargin              17
#define KCommentToolBarDistance                 5
#define KCommentToolBarTextView_Emotion         17
#define KCommentToolBarEmotion_SendBtn          0

#define KCommentToolBarResizeableHeight         48
#define KCommentTextViewResizeableHeight        32
#define KCommentToolBarNormalHeight             48
#define KCommentTextViewNormalHeight            32

@interface BaseCommentToolBar ()<US2ValidatorUIDelegate, QMUITextViewDelegate, QMUITextFieldDelegate>
@property(nonatomic, copy) BaseCommentToolBarActionBlock actionBlock;
@property(nonatomic, copy, readwrite) NSString *text;
@property(nonatomic, strong) US2ValidatorTextView *textView;
@property(nonatomic, strong) US2ValidatorTextField *textField;
@property(nonatomic, strong) QMUIButton *sendButton;
@property(nonatomic, strong) QMUIButton *emotionButton;
@property(nonatomic, assign, getter=isHasEmotion) BOOL hasEmotion;
@property(nonatomic, weak) QMUIQQEmotionManager *qqEmotionManager;
@property(nonatomic, assign) BOOL autoResizeble;
@property(nonatomic, strong) UIView *textViewContainer;
@property(nonatomic, strong) UIView *bottomLineView;
@property(nonatomic, assign) CGFloat maxExpandHeight;
@property(nonatomic, strong) UIImageView *topShadowImgView;
@end

@implementation BaseCommentToolBar

- (instancetype)init
{
        return [self initWithEmotion:NO];
}
- (instancetype)initWithFrame:(CGRect)frame
{
        return [self initWithEmotion:NO];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
        return [self initWithEmotion:NO];
}

- (instancetype)initWithEmotion:(BOOL)emotion
{
        if (self = [super initWithFrame:CGRectZero])
        {
                self.hasEmotion = emotion;
                [self _SetupView];
                self.backgroundColor = [UIColor whiteColor];
        }
        return self;
}
- (NSString *)text
{
        return self.autoResizeble ? self.textView.validatableText : self.textField.validatableText;
}
- (id<US2ValidatorUIProtocol,UITextInput,UIContentSizeCategoryAdjusting>)realTextView
{
        return self.textView.isHidden ? self.textField : self.textView;
}
- (void)validatorUI:(id<US2ValidatorUIProtocol>)validatorUI changedValidState:(BOOL)isValid
{
        self.sendButton.enabled = isValid;
        if (self.actionBlock && !isValid) {
                self.actionBlock(BaseCommentToolBarActionTypeTextNotValid, self);
        }
}
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
        [super setBackgroundColor:backgroundColor];
        self.bottomLineView.backgroundColor = backgroundColor;
}
- (void)_SetupView
{
        self.topShadowImgView = [[UIImageView alloc] initWithImage:[UIImage comment_shadow]];
        self.bottomLineView = [[UIView alloc] init];
        self.bottomLineView.backgroundColor = self.backgroundColor;
        [self addSubview:self.bottomLineView];
        [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom);
                make.left.right.equalTo(self);
                make.height.mas_equalTo(10);
        }];
        UIView *textViewContainer = [[UIView alloc] init];
        textViewContainer.backgroundColor = [UIColor clearColor];
        [textViewContainer addSubview:self.textField];
        [textViewContainer addSubview:self.textView];
        [self addSubview:self.topShadowImgView];
        
        self.textViewContainer = textViewContainer;
        [self addSubview:textViewContainer];
        [self addSubview:self.sendButton];
        [self addSubview:self.emotionButton];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(textViewContainer);
        }];
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(textViewContainer);
        }];
        [self.topShadowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_top);
                make.left.right.equalTo(self);
                make.height.mas_equalTo(2);
        }];
        @weakify(self);
        [self.sendButton jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (self.actionBlock) {
                        self.actionBlock(BaseCommentToolBarActionTypeSend, self);
                }
        }];
        [self.emotionButton jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (self.actionBlock) {
                        self.emotionButton.selected = !self.emotionButton.selected;
                        self.actionBlock(self.emotionButton.isSelected ? BaseCommentToolBarActionTypeShowEmotion : BaseCommentToolBarActionTypeHideEmotion, self);
                        
                }
        }];
        [self _ReLayoutView];
}
- (void)_ReLayoutView
{
        [self.textViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(KCommentToolBarLeftMargin);
                make.top.equalTo(self).offset(KCommentToolBarTopMargin);
                make.bottom.equalTo(self).offset(-KCommentToolBarBottomMargin);
                if (self.autoResizeble)
                {
                        make.height.mas_equalTo(KCommentTextViewResizeableHeight);
                }
                else
                {
                        make.height.mas_equalTo(KCommentTextViewNormalHeight);
                }
        }];
        if (!self.autoResizeble)
        {
                self.realTextView.layer.cornerRadius = KCommentTextViewNormalHeight * 0.5;
                self.realTextView.clipsToBounds = YES;
        }
        else
        {
                self.realTextView.layer.borderColor  = [UIColor clearColor].CGColor;
                self.realTextView.layer.cornerRadius = 1.0;
                self.realTextView.clipsToBounds = YES;
        }
        self.emotionButton.hidden = !self.hasEmotion;
        [self.emotionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.textView.mas_right).offset(KCommentToolBarTextView_Emotion);
                make.width.mas_equalTo(self.hasEmotion ? KCommentToolBarSendBtnWidth : 0);
                if (self.autoResizeble)
                {
                        make.bottom.equalTo(self).offset(-KCommentToolBarBottomMargin);
                }
                else
                {
                        make.top.bottom.equalTo(self.textViewContainer);
                }
        }];
        [self.sendButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.emotionButton.mas_right).offset(self.hasEmotion ? KCommentToolBarDistance : 0);
                make.right.equalTo(self.mas_right).offset(-KCommentToolBarRightMargin);
                make.width.mas_equalTo(KCommentToolBarSendBtnWidth);
                make.top.bottom.equalTo(self.emotionButton);
        }];
        
}
/// MARK: TextView Delegate

- (void)textViewDidChangeSelection:(UITextView *)textView
{
        self.qqEmotionManager.selectedRangeForBoundTextInput = [self.textView qmui_convertNSRangeFromUITextRange:textView.selectedTextRange];
}
/// MARK: - QMUITextView delegate
- (void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height
{
        [self.textViewContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(MIN(MAX(height, KCommentTextViewResizeableHeight), self.maxExpandHeight));
        }];
}
- (BOOL)textViewShouldReturn:(QMUITextView *)textView
{
        if (self.actionBlock) {
                self.actionBlock(BaseCommentToolBarActionTypeSend, self);
        }
        return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
        if ([self.delegate respondsToSelector:@selector(commentToolBarWillHide:)]) {
                return [self.delegate commentToolBarWillShow:self];
        }
        return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
        self.emotionButton.selected = NO;
        if ([self.delegate respondsToSelector:@selector(commentToolBarWillShow:)]) {
                return [self.delegate commentToolBarWillShow:self];
        }
        return YES;
}

/// MARK: TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
        self.emotionButton.selected = NO;
        if ([self.delegate respondsToSelector:@selector(commentToolBarWillShow:)]) {
                return [self.delegate commentToolBarWillShow:self];
        }
        return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
        self.qqEmotionManager.selectedRangeForBoundTextInput = self.textField.qmui_selectedRange;
        if ([self.delegate respondsToSelector:@selector(commentToolBarWillHide:)]) {
                return [self.delegate commentToolBarWillShow:self];
        }
        return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        if (self.actionBlock) {
                self.actionBlock(BaseCommentToolBarActionTypeSend, self);
        }
        return YES;
}


/// MARK: - Protocol
- (void)setPlaceHolder:(id)placeHolder
{
        if (placeHolder == nil) {
                return;
        }
        if ([placeHolder isKindOfClass:[NSString class]]) {
                self.textView.placeholder = placeHolder;
                self.textField.placeholder = placeHolder;
        } else if ([placeHolder isKindOfClass:[NSAttributedString class]]) {
                self.textView.attributePlaceholder = placeHolder;
                self.textField.attributedPlaceholder = placeHolder;
        }
}
- (void)setMaxExpandHeight:(CGFloat)maxExpandHeight
{
        _maxExpandHeight = MAX(maxExpandHeight, KCommentTextViewResizeableHeight);
}
- (BOOL)isShowingEmotion
{
        return self.emotionButton.isSelected;
}
- (void)setToolBarActionBlock:(BaseCommentToolBarActionBlock)actionBlock
{
        self.actionBlock = actionBlock;
}
- (void)setEmotionManager:(QMUIQQEmotionManager *)emotionManager
{
        self.qqEmotionManager = emotionManager;
}
- (void)setAutoResizable:(BOOL)autoResizable
{
        _autoResizeble = autoResizable;
        self.textView.autoResizable = autoResizable;
        self.textField.hidden = autoResizable;
        self.textView.hidden = !autoResizable;
        [self _ReLayoutView];
}
- (US2ValidatorTextView *)textView
{
        if (_textView == nil) {
                _textView = [[US2ValidatorTextView alloc] init];
                _textView.validatorUIDelegate = self;
                _textView.returnKeyType      = UIReturnKeySend;
                _textView.clipsToBounds      = YES;
                _textView.font               = WGSystem14Font;
                _textView.backgroundColor    = UIColorGray8;
                _textView.textAlignment      = NSTextAlignmentLeft;
                _textView.placeholderColor = UIColorGray5;
                _textView.textColor = UIColorGray5;
                _textView.tintColor = UIColorHex(0xf6645f);
                
        }
        return _textView;
}
- (US2ValidatorTextField *)textField
{
        if (_textField == nil) {
                _textField = [[US2ValidatorTextField alloc] init];
                _textField.validatorUIDelegate = self;
                _textField.returnKeyType      = UIReturnKeySend;
                _textField.borderStyle        = UITextBorderStyleNone;
                _textField.tintColor = UIColorHex(0xf6645f);
                _textField.clipsToBounds      = YES;
                _textField.font               = WGSystem14Font;
                _textField.backgroundColor    = UIColorGray8;
                _textField.textAlignment      = NSTextAlignmentLeft;
                _textField.minimumFontSize    = 15.0;
                _textField.placeholderColor   = UIColorGray5;
                _textField.placeholderFont = WGSystem14Font;
                _textField.textColor = UIColorGray5;
                _textField.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        }
        return _textField;
}
- (QMUIButton *)sendButton
{
        if (!_sendButton)
        {
                _sendButton = [[QMUIButton alloc] initWithFrame:CGRectZero];
                _sendButton.enabled = NO;
                _sendButton.qmui_outsideEdge = UIEdgeInsetsMake(-KCommentToolBarTopMargin, -KCommentToolBarDistance, -KCommentToolBarBottomMargin, -KCommentToolBarRightMargin);
                _sendButton.titleLabel.font = WGSystem14Font;
                [_sendButton setTitleColor:UIColorGray5 forState:UIControlStateDisabled];
                [_sendButton setTitleColor:UIColorHex(0x333333) forState:(UIControlStateNormal)];
                _sendButton.adjustsImageWhenHighlighted = NO;
                [_sendButton setTitle:[NSString app_Send] forState:UIControlStateNormal];
        }
        return _sendButton;
}
- (QMUIButton *)emotionButton
{
        if (_emotionButton == nil) {
                _emotionButton = [[QMUIButton alloc] initWithFrame:CGRectZero];
                _emotionButton.titleLabel.font = WGSystem14Font;
                [_emotionButton setImage:[[UIImage wo_de_nor] qmui_imageWithTintColor:UIColorGray5] forState:UIControlStateNormal];
                [_emotionButton setImage:[UIImage wo_de_sel] forState:UIControlStateSelected];
        }
        return _emotionButton;
}
@end
