//
//  NSMutableArray+SafeKit.m
//  DurexKitExample
//
//  Created by zhangyu on 14-3-13.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSMutableArray+SafeKit.h"
#import "NSObject+Swizzle.h"
#import "SafeKitLog.h"
#import "NSException+SafeKit.h"

@implementation NSMutableArray(SafeKit)
-(id)SKobjectAtIndex:(NSUInteger)index{
	if (index >= [self count]) {
		[[SafeKitLog shareInstance]logWarning:[NSString stringWithFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]];
		return nil;
	}
	return [self SKobjectAtIndex:index];
}
//- (NSArray *)SKarrayByAddingObject:(id)anObject{
//    if (!anObject) {
//        [[SafeKitLog shareInstance]logWarning:[NSString stringWithFormat:@"object is nil"]];
//        return nil;
//    }
//    return [self SKarrayByAddingObject:anObject];
//}

-(void)SKaddObject:(id)anObject{
	if (!anObject) {
		[[SafeKitLog shareInstance]logWarning:@"object is nil"];
		return;
	}
	[self SKaddObject:anObject];
}
- (void)SKinsertObject:(id)anObject atIndex:(NSUInteger)index{
	if (index > [self count]) {
		[[SafeKitLog shareInstance]logWarning:[NSString stringWithFormat:@"index[%ld] > count[%ld]",(long)index ,(long)[self count]]];
		return;
	}
	if (!anObject) {
		[[SafeKitLog shareInstance]logWarning:@"object is nil"];
		return;
	}
	[self SKinsertObject:anObject atIndex:index];
}

- (void)SKremoveObjectAtIndex:(NSUInteger)index{
	if (index >= [self count]) {
		[[SafeKitLog shareInstance]logWarning:[NSString stringWithFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]];
		return;
	}
	
	return [self SKremoveObjectAtIndex:index];
}
- (void)SKreplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
	if (index >= [self count]) {
		[[SafeKitLog shareInstance]logWarning:[NSString stringWithFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]];
		return;
	}
	if (!anObject) {
		[[SafeKitLog shareInstance]logWarning:@"object is nil"];
		return;
	}
	[self SKreplaceObjectAtIndex:index withObject:anObject];
}


- (void)SKsetObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
	if (obj == nil || idx >= self.count)
	{
		@try
		{
			[self SKsetObject:obj atIndexedSubscript:idx];
		}
		@catch (NSException *exception)
		{
			[[SafeKitLog shareInstance] logError:[NSString stringWithFormat:@"Crash Because %@",[exception callStackSymbols]]];
			
		} @finally {
			
		}
		
	}
	else
	{
		[self SKsetObject:obj atIndexedSubscript:idx];
	}
	
}

- (void)SKremoveObject:(id)anObject
{
	@try {
		[self SKremoveObject:anObject];
	} @catch (NSException *exception) {
		
		[[SafeKitLog shareInstance] logError:[NSString stringWithFormat:@"Crash Because %@",[exception callStackSymbols]]];
		
	} @finally {
		
	}
}

- (void)SKinsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes
{
	@try {
		[self SKinsertObjects:objects atIndexes:indexes];
	} @catch (NSException *exception) {
		
		[[SafeKitLog shareInstance] logError:[NSString stringWithFormat:@"Crash Because %@",[exception callStackSymbols]]];
		
	} @finally {
		
	}
}

+ (void) load{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self swizzleMethod:@selector(SKobjectAtIndex:) tarClass:@"__NSArrayM" tarSel:@selector(objectAtIndex:)];
		//        [self swizzleMethod:@selector(SKarrayByAddingObject:) tarClass:@"__NSArrayM" tarSel:@selector(arrayByAddingObject:)];
		
		[self swizzleMethod:@selector(SKaddObject:) tarClass:@"__NSArrayM" tarSel:@selector(addObject:)];
		[self swizzleMethod:@selector(SKinsertObject:atIndex:) tarClass:@"__NSArrayM" tarSel:@selector(insertObject:atIndex:)];
		[self swizzleMethod:@selector(SKremoveObjectAtIndex:) tarClass:@"__NSArrayM" tarSel:@selector(removeObjectAtIndex:)];
		[self swizzleMethod:@selector(SKreplaceObjectAtIndex:withObject:) tarClass:@"__NSArrayM" tarSel:@selector(replaceObjectAtIndex:withObject:)];
		
		[self swizzleMethod:@selector(SKsetObject:atIndexedSubscript:) tarClass:@"__NSArrayM" tarSel:@selector(setObject:atIndexedSubscript:)];
		[self swizzleMethod:@selector(SKremoveObject:) tarClass:@"__NSArrayM" tarSel:@selector(removeObject:)];
		[self swizzleMethod:@selector(SKinsertObjects:atIndexes:) tarClass:@"__NSArrayM" tarSel:@selector(insertObjects:atIndexes:)];
		
		
	});
}
@end
