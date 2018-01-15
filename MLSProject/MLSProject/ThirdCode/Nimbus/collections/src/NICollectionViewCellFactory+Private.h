//
//  NICollectionViewCellFactory+Private.h
//  MLSProject
//
//  Created by MinLison on 2017/12/1.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "NICollectionViewCellFactory.h"

@interface NINibCollectionViewCellObject ()

// A property to change the cell class of this cell object.
@property (assign, nonatomic) Class collectionViewCellClass;

@property (strong, nonatomic) UINib *collectionViewCellNib;
@end

@interface NICollectionViewCellObject ()
// A property to change the cell class of this cell object.
@property (assign, nonatomic) Class collectionViewCellClass;
@end
