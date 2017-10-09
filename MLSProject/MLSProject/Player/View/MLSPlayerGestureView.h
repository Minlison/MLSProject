//
//  MLSPlayerGestureView.h
//  MLSProject
//
//  Created by MinLison on 2017/3/9.
//  Copyright © 2017年 com.minlison.orgz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 移动的数值
 */
struct MLSPlayerMovedValue
{
	float vertical;
	float horizontal;
};
typedef struct MLSPlayerMovedValue MLSPlayerMovedValue;
static inline MLSPlayerMovedValue MLSPlayerMovedValueMake(float horizontal,float vertical)
{
	MLSPlayerMovedValue value;
	value.horizontal = horizontal;
	value.vertical = vertical;
	return value;
}

// 手势状态
typedef NS_ENUM(int, MLSPlayerGestureState)
{
	MLSPlayerGestureStateStart = UIGestureRecognizerStateBegan, 	// 开始
	MLSPlayerGestureStateMoved = UIGestureRecognizerStateChanged, 	// 移动
	MLSPlayerGestureStateEnd = UIGestureRecognizerStateEnded,	// 结束
};
// 竖向移动,在屏幕的位置
typedef NS_OPTIONS(NSInteger, MLSPlayerPosition)
{
	MLSPlayerPositionNone = 0,		// 0
	// 以屏幕左右二等分
	MLSPlayerPositionLeft	= 1 << 0,	// 1
	MLSPlayerPositionRight	= 1 << 1,	// 2
	
	// 以屏幕上下二等分
	MLSPlayerPositionTop	= 1 << 2,	// 4
	MLSPlayerPositionBootom	= 1 << 3,	// 8
	
	// 左上
	MLSPlayerPositionLeftTop = MLSPlayerPositionLeft | MLSPlayerPositionTop,	// 5
	// 左下
	MLSPlayerPositionLeftBootom = MLSPlayerPositionLeft | MLSPlayerPositionBootom,	// 9
	// 右上
	MLSPlayerPositionRightTop = MLSPlayerPositionRight | MLSPlayerPositionTop,		// 6
	// 右下
	MLSPlayerPositionRightBootom = MLSPlayerPositionRight | MLSPlayerPositionBootom,   // 10
};
// 移动方向,判断有误差
typedef NS_OPTIONS(NSInteger, MLSPlayerMoveDirection)
{
	MLSPlayerMoveDirectionNone	= 0,
	// 以屏幕左右二等分
	MLSPlayerMoveDirectionLeft	= 1 << 0,	// 1
	MLSPlayerMoveDirectionRight	= 1 << 1,	// 2
	
	// 以屏幕上下二等分
	MLSPlayerMoveDirectionTop	= 1 << 2,	// 4
	MLSPlayerMoveDirectionBootom	= 1 << 3,	// 8
	
	// 左上
	MLSPlayerMoveDirectionLeftTop = MLSPlayerMoveDirectionLeft | MLSPlayerMoveDirectionTop,		// 5
	// 左下
	MLSPlayerMoveDirectionLeftBootom = MLSPlayerMoveDirectionLeft | MLSPlayerMoveDirectionBootom,	// 9
	// 右上
	MLSPlayerMoveDirectionRightTop = MLSPlayerMoveDirectionRight | MLSPlayerMoveDirectionTop,		// 6
	// 右下
	MLSPlayerMoveDirectionRightBootom = MLSPlayerMoveDirectionRight | MLSPlayerMoveDirectionBootom,	// 10
};

@protocol MLSPlayerGestureViewDelegate <NSObject>

/**
 点按手势
 三次连续点击
 @param state 手势状态
 */
- (void)playerGestureTap:(MLSPlayerGestureState)state;

/**
 连按手势
 三次连续点击
 @param state 手势状态
 */
- (void)playerGestureThirdTap:(MLSPlayerGestureState)state;

/**
 手势移动,起始位置, 移动方向, 移动距离
 
 @param state 状态
 @param position 起始位置
 @param direction 移动方向
 @param value 移动的距离
 */
- (void)playerGestureMoved:(MLSPlayerGestureState)state StartPosition:(MLSPlayerPosition)position direction:(MLSPlayerMoveDirection)direction valueChanged:(MLSPlayerMovedValue)value;

/**
 手势缩放比例

 @param state 状态
 @param scale 减少会增加的比例
 */
- (void)playerGestureScale:(MLSPlayerGestureState)state scale:(CGFloat)scale;
@end

@interface MLSPlayerGestureView : UIControl

@property (weak, nonatomic) id <MLSPlayerGestureViewDelegate> delegate;

@end
