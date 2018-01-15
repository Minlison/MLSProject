//
//  EFBlockBasedArray.h
//  EFAnimation
//
//  Created by Robert Böhnke on 10/11/13.
//  Modified by AaronYi
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^EFBlockBasedArrayBlock)(NSUInteger idx);

@interface EFBlockBasedArray : NSArray

+ (instancetype)arrayWithCount:(NSUInteger)count block:(EFBlockBasedArrayBlock)block;

- (instancetype)initWithCount:(NSUInteger)count block:(EFBlockBasedArrayBlock)block;

@end
