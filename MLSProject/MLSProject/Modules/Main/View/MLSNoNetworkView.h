//
//  MLSNoNetworkView.h
//  minlison
//
//  Created by MinLison on 15/9/16.
//  Copyright (c) 2015年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLSNoNetworkView : QMUIEmptyView
@property (copy, nonatomic) void (^refreshBlock)(void);
+ (instancetype)noNetworkView;
- (void)setConvenienceRefreshBlock:(void(^)())refreshBlock;
@end

