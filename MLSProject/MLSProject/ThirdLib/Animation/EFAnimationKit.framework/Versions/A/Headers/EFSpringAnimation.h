//
//  EFSpringAnimation.h
//  EFAnimation
//
//  Created by Robert Böhnke on 10/14/13.
//  Modified by AaronYi
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "EFAnimation.h"

@interface EFSpringAnimation : EFAnimation

@property (readwrite, nonatomic, assign) CGFloat damping;
@property (readwrite, nonatomic, assign) CGFloat mass;
@property (readwrite, nonatomic, assign) CGFloat stiffness;
@property (readwrite, nonatomic, assign) CGFloat velocity;

@property (readwrite, nonatomic, strong) NSValue *fromValue;
@property (readwrite, nonatomic, strong) NSValue *toValue;

@property (readwrite, nonatomic, assign) BOOL allowsOverdamping;

- (CFTimeInterval)durationForEpsilon:(double)epsilon;

@end
