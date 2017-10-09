//
//  NSSet+Accessors.h
//  SampleProject
//
//  Created by Marin Usalj on 11/23/12.
//  Copyright (c) 2012 @supermarin | supermar.in. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet<ObjectType> (Accessors)

/// Returns the first object of a given set.
/// Note that sets are unordered, so this method won't always return the same thing
@property(readonly) ObjectType firstObject;

/// Returns the last object of a given set.
/// Note that sets are unordered, so this method won't always return the same thing
@property(readonly) ObjectType lastObject;


/// Alias for -anyObject. Returns a random object from a given set
@property(readonly) ObjectType sample;

/// Alias for -anyObject. Returns a random object from a given set
- (void)each:(void (^)(ObjectType object))block;
- (void)eachWithIndex:(void (^)(ObjectType object, NSUInteger index))block;

/// Filters the given set using provided block, and returns an array copy
- (NSArray <ObjectType>*)select:(BOOL (^)(ObjectType object))block;

/// Keeps the objects passing the given block, and returns an array copy
- (NSArray <ObjectType>*)reject:(BOOL (^)(ObjectType object))block;

/// Returns a sorted array copy of the given set
- (NSArray <ObjectType>*)sort;

/**
 *  Maps the given NSSet to NSArray.
 *  NOTE: If the block returns `-nil`, values are ignored.
 *        This is intentional to keep the behavior of `-valueForKeyPath`.
 *        This is different from NSArray `-map`, which puts NSNulls in the given case.
 *        If you want to preserve the count and use NSNulls, use `set.allObjects -map:`
 *
 *  @param block - a transform block
 *
 *  @return An NSArray copy of the transformed set.
 */
- (NSArray *)map:(id (^)(ObjectType object))block;

/**
 Return a single value from an array by iterating through the elements and transforming a running total.

 @return A single value that is the end result of apply the block function to each element successively.
 **/
- (ObjectType)reduce:(id (^)(ObjectType accumulator, ObjectType object))block;

/**
 Same as -reduce, with initial value provided by yourself
 **/
- (ObjectType)reduce:(ObjectType)initial withBlock:(id (^)(id accumulator, ObjectType object))block;


#pragma mark - Deprecations

@property(readonly) id first DEPRECATED_MSG_ATTRIBUTE("Please use -firstObject");
@property(readonly) id last  DEPRECATED_MSG_ATTRIBUTE("Please use -lastObject");

@end
