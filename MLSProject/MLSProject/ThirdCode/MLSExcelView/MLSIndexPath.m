//
//  MLSIndexPath.m
//  10000ui-swift
//
//  Created by MinLison on 09/10/2017.
//  Copyright © 2017 yizmh. All rights reserved.
//

#import "MLSIndexPath.h"

@implementation MLSIndexPath

+ (instancetype)indexPathForColumn:(NSInteger)column inRow:(NSInteger)row {
    MLSIndexPath *indexPath = [MLSIndexPath new];
    indexPath->_column = column;
    indexPath->_row = row;
    return indexPath;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"row = %ld, column = %ld", (long)self.row, (long)self.column];
}

@end
