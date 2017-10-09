//
//  MLSPlayerGestureView.m
//  MLSProject
//
//  Created by MinLison on 2017/3/9.
//  Copyright © 2017年 com.minlison.orgz. All rights reserved.
//

#import "MLSPlayerGestureView.h"
#define __DELEGATE__CALL__(block)\
if (self.delegate)\
{\
block();\
}
#define ZOOM_PINCH_COUNT 0
@interface MLSPlayerGestureView() <UIGestureRecognizerDelegate>
@property (assign, nonatomic, getter=isHorizontal) BOOL horizontal;
@property (assign, nonatomic) MLSPlayerMoveDirection direction;
@property (assign, nonatomic) MLSPlayerPosition position;
@property (assign, nonatomic) NSInteger pinchCount;
@end
@implementation MLSPlayerGestureView
- (instancetype)init
{
	if (self = [super init]) {
		[self _InitGestures];
	}
	return self;
}
- (void)_InitGestures
{
	UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesturePinch:)];
	pinchGesture.delegate = self;
	
	[self addGestureRecognizer:pinchGesture];
	
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesturePan:)];
	panGesture.delegate = self;
	panGesture.maximumNumberOfTouches = 1;
	panGesture.minimumNumberOfTouches = 1;
	[self addGestureRecognizer:panGesture];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTap:)];
	[self addGestureRecognizer:tapGesture];
	tapGesture.delegate = self;
        
        UITapGestureRecognizer *thirdTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTap:)];
        thirdTapGesture.numberOfTapsRequired = 3;
        [self addGestureRecognizer:thirdTapGesture];
        thirdTapGesture.delegate = self;
}
// MARK: - Gesture target Method
- (void)tapGestureTap:(UITapGestureRecognizer *)tapGesture
{
	__DELEGATE__CALL__(^{
                if (tapGesture.numberOfTapsRequired == 3)
                {
                        [self.delegate playerGestureThirdTap:(MLSPlayerGestureState)(tapGesture.state)];
                }
                else
                {
                        [self.delegate playerGestureTap:(MLSPlayerGestureState)(tapGesture.state)];
                }
	});
}
- (void)pinchGesturePinch:(UIPinchGestureRecognizer *)gestureRecognizer
{
	NSUInteger touches = [gestureRecognizer numberOfTouches];
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
	{
		[self _StartPinchGesture:gestureRecognizer];
		
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
	{
		if (touches == 2)
		{
			self.pinchCount ++;
			
			if (self.pinchCount >= ZOOM_PINCH_COUNT)
			{
				self.pinchCount = 0;
				__DELEGATE__CALL__(^{
					CGFloat velocity = gestureRecognizer.velocity;
					if (isnan(velocity))
					{
						velocity = 0.0;
					}
					[self.delegate playerGestureScale:(MLSPlayerGestureState)gestureRecognizer.state scale:gestureRecognizer.velocity * 0.1];
				});
			}
		}
	}
	else
	{
		__DELEGATE__CALL__(^{
			[self.delegate playerGestureScale:(MLSPlayerGestureState)gestureRecognizer.state scale:0];
		});
	}
}

- (void)panGesturePan:(UIPanGestureRecognizer *)panGesture
{
	CGPoint velocity = [panGesture velocityInView:self];
	if (panGesture.state == UIGestureRecognizerStateBegan)
	{
		self.position = MLSPlayerPositionNone;
		self.direction = MLSPlayerMoveDirectionNone;
	}
	else if (panGesture.state == UIGestureRecognizerStateChanged)
	{
		[self _StartPanGesture:panGesture];
		CGFloat x = (velocity.x) / (5000.0 * 2);
		CGFloat y = (-velocity.y) / (5000.0 * 2);
		__DELEGATE__CALL__(^{
			[self.delegate playerGestureMoved:(MLSPlayerGestureStateMoved) StartPosition:(self.position) direction:self.direction valueChanged:(MLSPlayerMovedValueMake(x, y))];
		});
	}
	else
	{
		CGPoint translation = [panGesture translationInView:self];
		CGFloat x = (translation.x);
		CGFloat y = (-translation.y);
		__DELEGATE__CALL__(^{
			[self.delegate playerGestureMoved:(MLSPlayerGestureStateEnd) StartPosition:(self.position) direction:self.direction valueChanged:(MLSPlayerMovedValueMake(x, y))];
		});
	}
}

// MARK: - Gesture Delegate Method
- (void)_StartPinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.numberOfTouches == 2)
	{
		__DELEGATE__CALL__(^{
			[self.delegate playerGestureScale:(MLSPlayerGestureStateStart) scale:0];
		});
	}
}

- (void)_StartPanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
	if (self.position == MLSPlayerPositionNone || self.direction == MLSPlayerMoveDirectionNone)
	{
		CGPoint lastPoint = [gestureRecognizer locationInView:self];
		
		UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
		CGPoint translation = [panGesture translationInView:self];
		
		BOOL horizontal = NO;
		MLSPlayerPosition position = MLSPlayerPositionNone;
		MLSPlayerMoveDirection direction = MLSPlayerMoveDirectionNone;
		
		// 判断方向
		if (translation.x > 0)
		{
			direction |= MLSPlayerMoveDirectionRight;
		}
		else if (translation.x < 0)
		{
			direction |= MLSPlayerMoveDirectionLeft;
		}
		
		if (translation.y > 0)
		{
			direction |= MLSPlayerMoveDirectionBootom;
		}
		else if (translation.y < 0)
		{
			direction |= MLSPlayerMoveDirectionTop;
		}
		
		// 判断是横向还是竖向移动
		if ( ( (ABS(translation.x) - ABS(translation.y) ) > 0 ))
		{
			horizontal = YES;
		}
		
		// 判断是在左边,还是在右边
		if (lastPoint.x < [UIScreen mainScreen].bounds.size.width * 0.5)
		{
			position |= MLSPlayerPositionLeft;
		}
		else
		{
			position |= MLSPlayerPositionRight;
		}
		
		self.direction = direction;
		self.position = position;
		
		__DELEGATE__CALL__(^{
			[self.delegate playerGestureMoved:(MLSPlayerGestureStateStart) StartPosition:(position) direction:direction valueChanged:(MLSPlayerMovedValueMake(0, 0))];
		});
	}
}
- (void)_StartTapGesture:(UITapGestureRecognizer *)gesture
{
	__DELEGATE__CALL__(^{
		[self.delegate playerGestureTap:(MLSPlayerGestureStateStart)];
	});
}
@end
