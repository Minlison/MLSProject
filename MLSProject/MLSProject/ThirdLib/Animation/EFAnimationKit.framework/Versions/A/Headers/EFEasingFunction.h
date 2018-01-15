//
//  EFEasingFunction.h
//  EFAnimation
//
//  Created by Robert Böhnke on 10/14/13.
//  Modified by AaronYi on 06/10/14.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef double (^EFEasingFunction)(CFTimeInterval t);

extern const CGFloat kElasticPeriod;
extern const CGFloat kElasticAmplitude;
extern const CGFloat kElasticShiftRatio;

extern EFEasingFunction const EFEasingFunctionLinear;

extern EFEasingFunction const EFEasingFunctionEaseInQuad;
extern EFEasingFunction const EFEasingFunctionEaseOutQuad;
extern EFEasingFunction const EFEasingFunctionEaseInOutQuad;

extern EFEasingFunction const EFEasingFunctionEaseInCubic;
extern EFEasingFunction const EFEasingFunctionEaseOutCubic;
extern EFEasingFunction const EFEasingFunctionEaseInOutCubic;

extern EFEasingFunction const EFEasingFunctionEaseInQuart;
extern EFEasingFunction const EFEasingFunctionEaseOutQuart;
extern EFEasingFunction const EFEasingFunctionEaseInOutQuart;

extern EFEasingFunction const EFEasingFunctionEaseInBounce;
extern EFEasingFunction const EFEasingFunctionEaseOutBounce;
extern EFEasingFunction const EFEasingFunctionEaseInOutBounce;

extern EFEasingFunction const EFEasingFunctionEaseInExpo;
extern EFEasingFunction const EFEasingFunctionEaseOutExpo;
extern EFEasingFunction const EFEasingFunctionEaseInOutExpo;

extern EFEasingFunction const EFEasingFunctionEaseInCircular;
extern EFEasingFunction const EFEasingFunctionEaseOutCircular;
extern EFEasingFunction const EFEasingFunctionEaseInOutCircular;

extern EFEasingFunction const EFEasingFunctionEaseInSine;
extern EFEasingFunction const EFEasingFunctionEaseOutSine;
extern EFEasingFunction const EFEasingFunctionEaseInOutSine;

extern EFEasingFunction EFEasingFunctionEaseInElastic(double period, double amplitude, double shiftRatio);
extern EFEasingFunction EFEasingFunctionEaseOutElastic(double period, double amplitude, double shiftRatio);


