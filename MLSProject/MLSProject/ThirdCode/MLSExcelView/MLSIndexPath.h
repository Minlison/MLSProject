//
//  MLSIndexPath.h
//  10000ui-swift
//
//  Created by MinLison on 09/10/2017.
//  Copyright © 2017 yizmh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface MLSIndexPath : NSObject

+ (instancetype)indexPathForColumn:(NSInteger)column inRow:(NSInteger)row;

@property (nonatomic, readonly) NSInteger column;
@property (nonatomic, readonly) NSInteger row;

NS_ASSUME_NONNULL_END
@end
