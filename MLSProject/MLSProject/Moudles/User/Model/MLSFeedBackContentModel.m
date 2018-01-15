//
//  MLSFeedBackContentModel.m
//  MinLison
//
//  Created by MinLison on 2017/11/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSFeedBackContentModel.h"
#import "MLSFeedBackHeadCell.h"
@implementation MLSFeedBackContentModel
- (Class)cellClass
{
        return [MLSFeedBackHeadCell class];
}
@end
