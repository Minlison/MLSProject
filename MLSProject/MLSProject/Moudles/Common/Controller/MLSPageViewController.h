//
//  MLSPageViewController.h
//  MinLison
//
//  Created by MinLison on 2017/11/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseViewController.h"
#import "WMPageController.h"
#import "HMSegmentedControl.h"
typedef NS_ENUM(NSInteger, WGSegmentScrollDirection)
{
        WGSegmentScrollDirectionHorizontal, // 横向
        WGSegmentScrollDirectionVertical, // 垂直
};

@protocol WGPageViewControllerDelegate <NSObject>

@optional
/**
 标题
 */
@property (strong, nonatomic) NSArray <NSString *>*segmentTitles;

/**
 segment
 */
@property (strong, readonly, nonatomic) HMSegmentedControl *segmentControl;

/**
 控制器个数
 
 @return 控制器个数
 */
- (NSInteger)countOfContentItems;

/**
 对应索引的控制器
 
 @param index 索引
 @return 控制器
 */
- (UIViewController *)contentControllerAtIndex:(NSInteger)index;

/**
 配置控制器
 
 @param controller 控制器
 @param index 索引
 */
- (void)configController:(UIViewController *)controller atIndex:(NSInteger)index;

/**
 控制器完全显示
 
 @param controller 控制器
 @param index 索引
 */
- (void)controllerDidShow:(UIViewController *)controller atIndex:(NSInteger)index;

/**
 是否有上层 segmet, 如果有, 才会调用 segmentTitles
 默认 YES
 */
- (BOOL)hasTopSegment;

/**
 滚动方向
 
 @return return value description
 */
- (WGSegmentScrollDirection)scrollDirection;

@end

@interface MLSPageViewController : WMPageController <WGPageViewControllerDelegate>

/**
 代理
 如果不设置，默认是 self
 */
@property(nonatomic, weak) id <WGPageViewControllerDelegate> pageDelegate;

/**
 顶部segment视图
 */
@property (strong, nonatomic, readonly) UIView *topSortView;

/**
 segment 底部线条颜色
 */
@property(nonatomic, strong) UIColor *topSortBottomLineColor;

/**
 自定义顶部视图， topSortBackgroundView 有值，会创建，但是不会布局
 */
@property(nonatomic, assign) BOOL customTopSortView;

/**
 标题
 */
@property (strong, nonatomic) NSArray <NSString *>*segmentTitles;

/**
 布局
 默认 {0，0，0，0}
 */
@property(nonatomic, assign) UIEdgeInsets segmentLayoutEdgeInsets;

/**
 选中控制器
 只有当 hastopSetment 返回 NO 的时候有效
 @param index 索引
 */
- (void)selectedController:(NSInteger)index;

/**
 选中控制器, 具有动画效果 (暂时只支持歌单)
 
 @param index 索引
 @param animation 动画
 */
- (void)selectedController:(NSInteger)index animation:(BOOL)animation;
/**
 是否可以滚动
 
 @param enable
 */
- (void)enableScroll:(BOOL)enable;
@end
