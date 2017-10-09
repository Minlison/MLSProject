//
//  MLSPlayerViewModel.m
//  MLSProject
//
//  Created by MinLison on 2017/9/12.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSPlayerViewModel.h"

@interface MLSPlayerViewModel ()
@property(nonatomic, strong) NSMutableArray *objs;
@property(nonatomic, assign) NSUInteger selectedIndex;
@end

@implementation MLSPlayerViewModel

- (NSArray <id>*)list
{
        return self.objs;
}

- (NSUInteger)size
{
        return self.objs.count;
}

- (void)add:(id)obj
{
        DebugAssert(obj != nil, @"插入数据不能为空");
        if (obj)
        {
                [self.objs addObject:obj];
        }
        
}

- (void)insert:(id)obj atIndex:(NSUInteger)index
{
        DebugAssert(obj != nil, @"插入数据不能为空");
        DebugAssert(index <= self.objs.count, @"索引不正确");
        if (obj != nil && index <= self.objs.count)
        {
                [self.objs insertObject:obj atIndex:index];
        }
}
- (id)objAtIndex:(NSUInteger)index
{
        if (index < self.objs.count) {
                return [self.objs objectAtIndex:index];
        }
        return nil;
}
- (NSUInteger)indexForObj:(id)obj
{
        DebugAssert(obj != nil, @"数据不能为空");
        if (obj != nil)
        {
                return [self.objs indexOfObject:obj];
        }
        return 0;
}

- (void)selectedObj:(id)obj
{
        self.selectedIndex = [self indexForObj:obj];
}

- (void)selectedIndex:(NSUInteger)index
{
        self.selectedIndex = index;
}

- (BOOL)replaceWithObj:(id)obj atIndex:(NSUInteger)index
{
        DebugAssert(obj != nil, @"数据不能为空");
        DebugAssert(index <= self.objs.count, @"索引不正确");
        if (obj && index < self.objs.count) {
                [self.objs replaceObjectAtIndex:index withObject:obj];
                return YES;
        }
        return NO;
}

- (id)first
{
        self.selectedIndex = 0;
        return self.objs.firstObject;
}

- (id)last
{
        self.selectedIndex = MAX(self.objs.count - 1, 0);
        return [self objAtIndex:self.selectedIndex];
}

- (id)pre
{
        if ( self.selectedIndex <= 0 )
        {
                return nil;
        }
        self.selectedIndex = MAX(self.selectedIndex - 1,0);
        return [self objAtIndex:self.selectedIndex];
}
- (BOOL)haveNext
{
        return self.selectedIndex < self.objs.count - 1;
}
- (id)next
{
        if ( self.selectedIndex >= self.objs.count - 1 )
        {
                return nil;
        }
        self.selectedIndex = MIN(self.selectedIndex + 1, MAX(self.objs.count - 1, 0));
        return [self objAtIndex:self.selectedIndex];
}
- (id)current
{
        return [self objAtIndex:self.selectedIndex];
}
- (NSMutableArray *)objs
{
        if (_objs == nil) {
                _objs = [[NSMutableArray alloc] init];
        }
        return _objs;
}

@end
