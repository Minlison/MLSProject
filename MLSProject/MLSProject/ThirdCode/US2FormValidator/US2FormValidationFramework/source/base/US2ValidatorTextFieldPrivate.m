//
//  US2ValidatorTextFieldPrivate.m
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

#import "US2ValidatorTextFieldPrivate.h"
#import "US2ConditionCollection.h"
#import "US2ValidatorTextField.h"
#import "US2Validator.h"
@interface US2ValidatorTextFieldPrivate()
@property(nonatomic, strong) WZProtocolInterceptor <US2ValidatorUIDelegate,QMUITextFieldDelegate>*delegateProxy;
@end

@implementation US2ValidatorTextFieldPrivate


@synthesize delegate           = _delegate;
@synthesize validatorTextField = _validatorTextField;


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
- (void)setDelegate:(id<US2ValidatorUIDelegate, QMUITextFieldDelegate>)delegate
{
        if (delegate == (id<US2ValidatorUIDelegate, QMUITextFieldDelegate>)self || delegate == nil) {
                _delegate = delegate;
                _validatorTextField.delegate = delegate;
                self.delegateProxy = nil;
                return;
        }
        _delegate = delegate;
        self.delegateProxy = (WZProtocolInterceptor <US2ValidatorUIDelegate,QMUITextFieldDelegate>*)[[WZProtocolInterceptor alloc] initWithInterceptedProtocols:@protocol(US2ValidatorUIDelegate),@protocol(QMUITextFieldDelegate), nil];
        self.delegateProxy.receiver = delegate;
        self.delegateProxy.middleMan = self;
        _validatorTextField.delegate = self.delegateProxy;
}
- (void)setValidatorTextField:(US2ValidatorTextField *)validatorTextField
{
        _validatorTextField = validatorTextField;
        // Listen for update of inherited UITextField
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:validatorTextField];
        
        // Listen for end of editing
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:validatorTextField];
}
#pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        NSString *futureString = textField.text;
        /// [string isKindOfClass:[NSMutableString class]] 判断是否是键盘正在输入中，键盘输入中，string 是 emoji 表情
//        if ((textField.markedTextRange == nil || textField.markedTextRange.isEmpty)) {
                futureString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        }
        
        US2ConditionCollection *conditions = [_validatorTextField.validator checkConditions:futureString];
        
        // Inform text field about valid state change
        if (conditions == nil)
        {
                [_validatorTextField validatorTextFieldPrivateSuccededConditions:self];
        }
        else
        {
                [_validatorTextField validatorTextFieldPrivate:self violatedConditions:conditions];
        }
        BOOL shouldAllowViolation = _validatorTextField.shouldAllowViolations;
        for (int i = 0; i < conditions.count; i++)
        {
                shouldAllowViolation = (shouldAllowViolation & [conditions conditionAtIndex:i].shouldAllowViolation);
        }
        // If condition is NULL no condition failed
        if (!_validatorTextField.validateOnFocusLossOnly && (NO == shouldAllowViolation))
        {
                if (!shouldAllowViolation)
                {
                        [self textFieldDidChange:nil];
                }
                if (string.length == 0 || futureString.length < textField.text.length  || futureString.length == 0) {
                        return YES;
                }
                return shouldAllowViolation;
        }
        
        // Ask delegate whether should change characters in range
        if ([self.delegateProxy.receiver respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
        {
                BOOL res = [self.delegateProxy.receiver textField:_validatorTextField shouldChangeCharactersInRange:range replacementString:string];
                if (!res)
                {
                        [self textFieldDidChange:nil];
                }
                return res;
        }
        return YES;
}

- (void)textFieldDidChange:(NSNotification *)notification
{
        // Only validate if violations are allowed
        if (_validatorTextField.shouldAllowViolations)
        {
                // Validate according to 'validateOnFocusLossOnly' while editing first time or after focus loss
                if (!_validatorTextField.validateOnFocusLossOnly
                    || (_validatorTextField.validateOnFocusLossOnly
                        && _didEndEditing))
                {
                        US2ConditionCollection *conditions = [_validatorTextField.validator checkConditions:_validatorTextField.text];
                        BOOL isValid = conditions == nil;
                        //            if (_lastIsValid != isValid)
                        {
                                _lastIsValid = isValid;
                                
                                // Inform text field about valid state change
                                if (isValid)
                                        [_validatorTextField validatorTextFieldPrivateSuccededConditions:self];
                                else
                                        [_validatorTextField validatorTextFieldPrivate:self violatedConditions:conditions];
                                
                                // Inform delegate about valid state change
                                if ([self.delegateProxy.receiver respondsToSelector:@selector(validatorUI:changedValidState:)])
                                        [self.delegateProxy.receiver validatorUI:_validatorTextField changedValidState:isValid];
                                
                                // Inform delegate about violation
                                if (!isValid)
                                {
                                        if ([self.delegateProxy.receiver respondsToSelector:@selector(validatorUI:violatedConditions:)])
                                                [self.delegateProxy.receiver validatorUI:_validatorTextField violatedConditions:conditions];
                                }
                        }
                }
        }
        
        // Inform delegate about changes
        if ([self.delegateProxy.receiver respondsToSelector:@selector(validatorUIDidChange:)])
                [self.delegateProxy.receiver validatorUIDidChange:_validatorTextField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
        // Ask delegate whether should begin editing
        if ([self.delegateProxy.receiver respondsToSelector:@selector(textFieldShouldBeginEditing:)])
                return [self.delegateProxy.receiver textFieldShouldBeginEditing:_validatorTextField];
        
        return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
        if ([self.delegateProxy.receiver respondsToSelector:@selector(textFieldDidBeginEditing:)])
                [self.delegateProxy.receiver textFieldDidBeginEditing:_validatorTextField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
        // Ask delegate whether should end editing
        if ([self.delegateProxy.receiver respondsToSelector:@selector(textFieldShouldEndEditing:)])
                return [self.delegateProxy.receiver textFieldShouldEndEditing:_validatorTextField];
        
        return YES;
}

/**
 * According to the feature of validating the text field after first focus loss we need to remember when
 * text field stopped editing.
 * After editing and focus loss try to validate the text field.
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
        // Remember focus loss
        _didEndEditing = YES;
        
        // Try to validate the text field after focus loss
        [self textFieldDidChange:nil];
        
        if ([self.delegateProxy.receiver respondsToSelector:@selector(textFieldDidEndEditing:)])
                [self.delegateProxy.receiver textFieldDidEndEditing:_validatorTextField];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
        // Ask delegate whether should clear
        if ([self.delegateProxy.receiver respondsToSelector:@selector(textFieldShouldClear:)])
                return [self.delegateProxy.receiver textFieldShouldClear:_validatorTextField];
        
        return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        // Ask delegate whether should return
        if ([self.delegateProxy.receiver respondsToSelector:@selector(textFieldShouldReturn:)])
                return [self.delegateProxy.receiver textFieldShouldReturn:_validatorTextField];
        
        return YES;
}


@end
