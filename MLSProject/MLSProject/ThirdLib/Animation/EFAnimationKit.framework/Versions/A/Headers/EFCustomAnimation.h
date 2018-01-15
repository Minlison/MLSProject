//
//  EFCustomAnimation.h
//  EFAnimation
//
//  Created by Robert Böhnke on 10/27/13.
//  Modified by AaronYi
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "EFAnimation.h"

@interface EFCustomAnimation : EFAnimation

@property (readwrite, nonatomic, copy) EFAnimationBlock animationBlock;

@end
