//
//  NSDictionary+ObjectiveSugar.h
//  SampleProject
//
//  Created by Marin Usalj on 11/23/12.
//  Copyright (c) 2012 @supermarin | supermar.in. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary <KeyType, ObjectType> (ObjectiveSugar)

- (void)each:(void (^)(KeyType key, ObjectType value))block;
- (void)eachKey:(void (^)(KeyType key))block;
- (void)eachValue:(void (^)(ObjectType value))block;
- (NSArray *)map:(id (^)(KeyType key, ObjectType value))block;
- (BOOL)hasKey:(KeyType)key;
- (NSDictionary *)pick:(NSArray *)keys;
- (NSDictionary *)omit:(NSArray *)keys;
- (NSDictionary *)merge:(NSDictionary *)dictionary;
- (NSDictionary *)merge:(NSDictionary *)dictionary block:(id (^)(KeyType key, ObjectType oldVal, ObjectType newVal))block;
- (NSDictionary *)invert;

@end
