//
//  BaseCollectionReusableView.m
//  MLSProject
//
//  Created by 袁航 on 2017/12/2.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseCollectionReusableView.h"

@implementation BaseCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
        if (self = [super initWithFrame:frame]) {
                [self setupView];
        }
        return self;
}
- (void)setupView
{
        self.backgroundColor = [UIColor whiteColor];
}
@end
