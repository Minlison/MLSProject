//
//  MLSPlayerModel.m
//  MLSProject
//
//  Created by MinLison on 2017/9/12.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSPlayerModel.h"
#import "Cache.h"
@implementation MLSPlayerModel
@synthesize current = _current;

- (void)setCurrent:(NSUInteger)current
{
        _current = current;
        [ShareStaticCache setObject:@(current) forKey:self.name.md5String];
}
- (NSUInteger)current
{
        if (_current > 0) {
                return _current;
        }
        _current = [(NSNumber *)[ShareStaticCache objectForKey:self.name.md5String] unsignedIntegerValue];
        if (_current > self.duration) {
                _current = 0;
        }
        return _current;
}
@end
