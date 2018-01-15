//
//  EFBasicAnimation.h
//  EFAnimation
//
//  Created by Robert Böhnke on 10/13/13.
//  Modified by AaronYi
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "EFAnimation.h"

#import "EFEasingFunction.h"

@interface EFBasicAnimation : EFAnimation

@property (readwrite, nonatomic, strong) NSValue *fromValue;
@property (readwrite, nonatomic, strong) NSValue *toValue;

@property (readwrite, nonatomic, copy) EFEasingFunction easing;

@end
