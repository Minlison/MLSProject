//
//  EFLinearInterpolation.h
//  EFAnimation
//
//  Created by Robert Böhnke on 10/25/13.
//  Modified by AaronYi
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef id (^EFLinearInterpolation)(CGFloat fraction);

extern EFLinearInterpolation EFInterpolate(NSValue *from, NSValue *to);
