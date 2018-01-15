//
//  MLSCommonSearchView.h
//  MLSProject
//
//  Created by MinLison on 2017/12/20.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseView.h"

@interface MLSCommonSearchView : BaseView
@property(nonatomic, assign) CGFloat searchContentCornerRadius;
@property(nonatomic, strong) UIColor *searchContentBorderColor;
@property(nonatomic, assign) CGFloat searchContentBorderWidth;
@property(nonatomic, assign) UIEdgeInsets searchTextFieldInset;
@property(nonatomic, strong) UIColor *searchFieldBackGroundColor;
@property(nonatomic, copy) NSString *placeHolder;
@property(nonatomic, copy) void (^searchActionBlock)(void);
@end
