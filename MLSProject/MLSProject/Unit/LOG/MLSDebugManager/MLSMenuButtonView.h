//
//  TLMenuButtonView.h
//  MiShu
//
//  Created by tianlei on 16/6/24.
//  Copyright © 2016年 Qzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLSMenuButtonView : UIView

@property (nonatomic, assign) CGPoint centerPoint;
@property (assign, nonatomic) CGRect menuBounds;

/**
 *  buttonItem 应该具有bounds
 */
@property (strong, nonatomic) NSArray <UIButton *>*menuItems;
/**
 *  两个球之间的间距
 */
@property (assign, nonatomic) CGFloat itemMargin;

@property (weak, nonatomic) UIView *ShowInSuperView;

@property (assign, nonatomic,getter=isShowing) BOOL showing;

+ (instancetype)standardMenuView;


- (void)showItems;

- (void)dismiss;
/** index  1 清除  2 隐藏  3 显示上次崩溃信息 */
@property (nonatomic, copy) void (^clickAddButton)(NSInteger index, id item);

@end
