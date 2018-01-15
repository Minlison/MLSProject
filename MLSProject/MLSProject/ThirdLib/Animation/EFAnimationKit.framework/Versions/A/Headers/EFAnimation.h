//
//  EFAnimation.h
//  EFAnimation
//
//  Created by Robert Böhnke on 10/10/13.
//  Modified by AaronYi on 04/28/14
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef id (^EFAnimationBlock)(CFTimeInterval t, CFTimeInterval duration);

@interface EFAnimation : CAKeyframeAnimation

@property (readonly, nonatomic, copy) EFAnimationBlock animationBlock;

@end

@interface EFAnimation (Unavailable)

- (void)setValues:(NSArray *)values __attribute__((unavailable("values cannot be set on EFAnimation")));

@end
