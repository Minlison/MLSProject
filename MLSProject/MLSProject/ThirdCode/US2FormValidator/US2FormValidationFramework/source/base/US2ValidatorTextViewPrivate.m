//
//  US2ValidatorTextViewPrivate.m
//  US2FormValidator
//
//  Copyright (C) 2012 ustwo™
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//  

#import "US2ValidatorTextViewPrivate.h"
#import "US2ConditionCollection.h"
#import "US2ValidatorTextView.h"
#import "US2Validator.h"

@interface US2ValidatorTextViewPrivate()
@property(nonatomic, strong) WZProtocolInterceptor <US2ValidatorUIDelegate,QMUITextViewDelegate>*delegateProxy;
@end

@implementation US2ValidatorTextViewPrivate


@synthesize delegate          = _delegate;
@synthesize validatorTextView = _validatorTextView;


#pragma mark - Initialization

- (id)init
{
        self = [super init];
        if (self)
        {
                _lastIsValid = -1;
        }
        
        return self;
}
- (void)setDelegate:(id<US2ValidatorUIDelegate,QMUITextViewDelegate>)delegate
{
        if (delegate == (id<US2ValidatorUIDelegate,QMUITextViewDelegate>)self || delegate == nil) {
                _delegate = delegate;
                _validatorTextView.delegate = delegate;
                self.delegateProxy = nil;
                return;
        }
        _delegate = delegate;
        self.delegateProxy = (WZProtocolInterceptor <US2ValidatorUIDelegate,QMUITextViewDelegate>*)[[WZProtocolInterceptor alloc] initWithInterceptedProtocols:@protocol(US2ValidatorUIDelegate),@protocol(QMUITextViewDelegate), nil];
        self.delegateProxy.receiver = delegate;
        self.delegateProxy.middleMan = self;
        _validatorTextView.delegate = self.delegateProxy;
}
- (void)setValidatorTextView:(US2ValidatorTextView *)validatorTextView
{
        _validatorTextView = validatorTextView;
        // Listen for end of editing
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:validatorTextView];
}
#pragma mark - Text view delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
        if ([self.delegateProxy.receiver respondsToSelector:@selector(textViewShouldBeginEditing:)])
                return [self.delegateProxy.receiver textViewShouldBeginEditing:_validatorTextView];
        
        return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
        if ([self.delegateProxy.receiver respondsToSelector:@selector(textViewShouldEndEditing:)])
                return [self.delegateProxy.receiver textViewShouldEndEditing:_validatorTextView];
        
        return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
        if ([self.delegateProxy.receiver respondsToSelector:@selector(textViewDidBeginEditing:)])
                [self.delegateProxy.receiver textViewDidBeginEditing:_validatorTextView];
}

/**
 According to the feature of validating the text field after first focus loss we need to remember when
 text field stopped editing.
 After editing and focus loss try to validate the text field.
 */
- (void)textViewDidEndEditing:(UITextView *)textView
{
        // Remember focus loss
        _didEndEditing = YES;
        
        // Try to validate the text field after focus loss
        [self textViewDidChange:textView];
        
        if ([self.delegateProxy.receiver respondsToSelector:@selector(textViewDidEndEditing:)])
                [self.delegateProxy.receiver textViewDidEndEditing:_validatorTextView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
        NSString *futureString = textView.text;
        /// [string isKindOfClass:[NSMutableString class]] 判断是否是键盘正在输入中，键盘输入中，string 是 emoji 表情
//        if ((textView.markedTextRange == nil || textView.markedTextRange.isEmpty)) {
        if (text) {
                futureString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        }
        
//        }
        
        US2ConditionCollection *conditions = [_validatorTextView.validator checkConditions:futureString];
        
        // Inform text field about valid state change
        if (conditions == nil)
        {
                [_validatorTextView validatorTextViewDelegateSuccededConditions:self];
        }
        else
        {
                [_validatorTextView validatorTextViewDelegate:self violatedConditions:conditions];
        }
        BOOL shouldAllowViolation = _validatorTextView.shouldAllowViolations;
        for (int i = 0; i < conditions.count; i++)
        {
                shouldAllowViolation = (shouldAllowViolation & [conditions conditionAtIndex:i].shouldAllowViolation);
        }
        // If condition is NULL no condition failed
        if (!_validatorTextView.validateOnFocusLossOnly && (NO == shouldAllowViolation ) )
        {
                if (!shouldAllowViolation)
                {
                        [self textViewDidChange:_validatorTextView];
                }
                if (text.length == 0 || futureString.length < textView.text.length || futureString.length == 0) {
                        return YES;
                }
                return shouldAllowViolation;
        }
        
        // Ask delegate whether should change characters in range
        if ([self.delegateProxy.receiver respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)])
                return [self.delegateProxy.receiver textView:_validatorTextView shouldChangeTextInRange:range replacementText:text];
        
        return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
        if (YES == _validatorTextView.shouldAllowViolations)
        {
                // Validate according to 'validateOnFocusLossOnly' while editing first time or after focus loss
                if (!_validatorTextView.validateOnFocusLossOnly
                    || (_validatorTextView.validateOnFocusLossOnly
                        && _didEndEditing))
                {
                        US2ConditionCollection *conditions = [_validatorTextView.validator checkConditions:_validatorTextView.text];
                        BOOL isValid = conditions == nil;
//                        if (_lastIsValid != isValid)
                        {
                                _lastIsValid = isValid;
                                
                                // Inform text field about valid state change
                                if (isValid)
                                        [_validatorTextView validatorTextViewDelegateSuccededConditions:self];
                                else
                                        [_validatorTextView validatorTextViewDelegate:self violatedConditions:conditions];
                                
                                // Inform delegate about valid state change
                                if ([self.delegateProxy.receiver respondsToSelector:@selector(validatorUI:changedValidState:)])
                                        [self.delegateProxy.receiver validatorUI:_validatorTextView changedValidState:isValid];
                                
                                // Inform delegate about violation
                                if (!isValid)
                                {
                                        if ([self.delegateProxy.receiver respondsToSelector:@selector(validatorUI:violatedConditions:)])
                                                [self.delegateProxy.receiver validatorUI:_validatorTextView violatedConditions:conditions];
                                }
                        }
                }
        }
        
        // Inform delegate about changes
        if ([self.delegateProxy.receiver respondsToSelector:@selector(validatorUIDidChange:)])
                [self.delegateProxy.receiver validatorUIDidChange:_validatorTextView];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
        if ([self.delegateProxy.receiver respondsToSelector:@selector(textViewDidChangeSelection:)])
                [self.delegateProxy.receiver textViewDidChangeSelection:_validatorTextView];
}

@end
