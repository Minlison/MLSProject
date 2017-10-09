//
//  NSArray+SafeKit.m
//  SafeKitExample
//
//  Created by zhangyu on 14-2-28.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSArray+SafeKit.h"
#import "NSObject+Swizzle.h"
#import "SafeKitLog.h"
#import "NSException+SafeKit.h"

@implementation NSArray(SafeKit)
+ (void) load{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self swizzleMethod:@selector(SKobjectAtIndex:) tarClass:@"__NSArrayI" tarSel:@selector(objectAtIndex:)];
		[self swizzleMethod:@selector(SKarrayWithObjects:count:) tarClass:@"__NSArrayI" tarSel:@selector(arrayWithObjects:count:)];
	});
}

-(id)SKobjectAtIndex:(NSUInteger)index{
	if (index >= [self count]) {
		[[SafeKitLog shareInstance]logWarning:[NSString stringWithFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]];
		return nil;
	}
	return [self SKobjectAtIndex:index];
}



+ (instancetype)SKarrayWithObjects:(const id _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt
{
	@try
	{
		return [self SKarrayWithObjects:objects count:cnt];
	}
	@catch (NSException *exception)
	{
		[[SafeKitLog shareInstance] logError:[NSString stringWithFormat:@"Crash Because %@",[exception callStackSymbols]]];
		
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wincompatible-pointer-types-discards-qualifiers"
		
		__unsafe_unretained id *unsafe_objects = objects;
		
#pragma clang diagnostic pop
		
		
		for (NSUInteger i = 0; i < cnt; i ++) {
			if (!unsafe_objects[i])
			{
				unsafe_objects[i] = @"";
			}
		}
		
		return [self SKarrayWithObjects:unsafe_objects count:cnt];
		
	}
	@finally
	{
	}
	
}
@end
