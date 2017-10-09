//
//  NSMutableArray+ObjectiveSugar.h
//  SampleProject
//
//  Created by Marin Usalj on 11/23/12.
//  Copyright (c) 2012 @supermarin | supermar.in. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray <ObjectType> (ObjectiveSugar)

/// Alias for -addObject. Appends the given object at the end
- (void)push:(ObjectType)object;

/**
 Removes the last item of the array, and returns that item
 Note: This method changes the length of the array!

 @return First array item or nil.
 */
- (ObjectType)pop;


/**
 Removes the last n items of the array, and returns that item
 Note: This method changes the length of the array!

 @return First array item or nil.
 */
- (NSArray <ObjectType>*)pop:(NSUInteger)numberOfElements;
- (void)concat:(NSArray <ObjectType>*)array;


/**
 Removes the first item of the array, and returns that item
 Note: This method changes the length of the array!

 @return First array item or nil.
 */
- (ObjectType)shift;


/**
 Removes N first items of the array, and returns that items
 Note: This method changes the length of the array!

 @return Array of first N items or empty array.
 */
- (NSArray <ObjectType>*)shift:(NSUInteger)numberOfElements;


/**
 Deletes every element of the array for which the given block evaluates to NO.

 @param block block that returns YES/NO
 @return An array of elements
 */
- (NSArray <ObjectType>*)keepIf:(BOOL (^)(ObjectType object))block;

@end
