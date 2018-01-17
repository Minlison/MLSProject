//
//  MLSNoNetworkView.h
//  LingVR
//
//  Created by Apple on 15/9/16.
//  Copyright (c) 2015年 LingVR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLSNoNetworkView : QMUIEmptyView
@property (copy, nonatomic) void (^refreshBlock)();
+ (instancetype)noNetworkView;
- (void)setConvenienceRefreshBlock:(void(^)())refreshBlock;
@end

