//
//  UIViewController+CZTopTip.m
//  LingVR
//
//  Created by qcm on 16/12/23.
//  Copyright © 2016年 LingVR. All rights reserved.
//

#import "UIViewController+CZTopTip.h"
#define KTIP_HEIGHT     40.0
CGPoint tipOffset;
@implementation UIViewController (CZTopTip)

@extSynthesizeAssociation(UIViewController,tipLabel)

- (void)showText:(NSString *)text animated:(BOOL)animated
{
        [self showText:text animated:animated showTime:2];
}

- (void)showText:(NSString *)text animated:(BOOL)animated showTime:(CGFloat)showTime
{
	[self showText:text textColor:[UIColor whiteColor] backgroundColor:__UIColorFromHexRGB(0x7F7F7F) offset:(CGPointZero) animated:animated showTime:showTime];
}
- (void)showText:(NSString *)text textColor:(UIColor *)color backgroundColor:(UIColor *)bkColor offset:(CGPoint)offset animated:(BOOL)animated showTime:(CGFloat)showTime
{
        if (text == nil) {
                return;
        }
        
        CGFloat NAV_TOP_HEIGHT = 20;
        
        UILabel *topTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, NAV_TOP_HEIGHT - KTIP_HEIGHT, __MAIN_SCREEN_WIDTH__, KTIP_HEIGHT)];
        self.tipLabel = topTipLabel;

	topTipLabel.backgroundColor = bkColor?:__UIColorFromHexRGB(0x7F7F7F);
	topTipLabel.font = WGSystem13Font;
	topTipLabel.textAlignment = NSTextAlignmentCenter;
	topTipLabel.textColor = color?:[UIColor whiteColor];
	
	topTipLabel.frame = CGRectMake(0,-(KTIP_HEIGHT+offset.y), __MAIN_SCREEN_WIDTH__, KTIP_HEIGHT);
	[self.view addSubview:topTipLabel];

        tipOffset = offset;
        topTipLabel.text = text;
        
        if (animated)
        {
                topTipLabel.alpha = 0.0;
                [UIView animateWithDuration:0.5 animations:^{
                        topTipLabel.alpha = 1.0;
                        CGRect tipFrame = topTipLabel.frame;
                        if (CGRectEqualToRect(self.view.bounds, self.navigationController.view.bounds)) {
                                tipFrame.origin.y = 0+offset.y+NAV_TOP_HEIGHT;
                        } else {
                                tipFrame.origin.y = 0+offset.y;
                        }
                        topTipLabel.frame = tipFrame;
                } completion:^(BOOL finished) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(showTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                [UIView animateWithDuration:0.3 delay:1.0 options:0 animations:^{
                                        topTipLabel.alpha = 0.0;
                                        CGRect tipFrame = topTipLabel.frame;
                                        tipFrame.origin.y = -(KTIP_HEIGHT+offset.y);
                                        topTipLabel.frame = tipFrame;
                                } completion:^(BOOL finished) {
                                        [topTipLabel removeFromSuperview];
                                        self.tipLabel = nil;
                                }];
                        });
                }];
        }
        else
        {
                topTipLabel.alpha = 1.0;
                CGRect tipFrame = topTipLabel.frame;
                if (CGRectEqualToRect(self.view.bounds, self.navigationController.view.bounds)) {
                        tipFrame.origin.y = 0+offset.y+NAV_TOP_HEIGHT;
                } else {
                        tipFrame.origin.y = 0+offset.y;
                }
                topTipLabel.frame = tipFrame;
        }
}
- (void)hideTip
{
        [CRToastManager dismissAllNotifications:YES];
        [self.view.layer removeAllAnimations];
        [UIView animateWithDuration:0.3 delay:1.0 options:0 animations:^{
                self.tipLabel.alpha = 0.0;
                CGRect tipFrame = self.tipLabel.frame;
                tipFrame.origin.y = -(KTIP_HEIGHT+tipOffset.y);
                self.tipLabel.frame = tipFrame;
        } completion:^(BOOL finished) {
                [self.tipLabel removeFromSuperview];
                self.tipLabel = nil;
        }];
}
- (void)showTextAtNavbar:(NSString *)text
{
        NSDictionary *options = @{
                                  kCRToastTextKey : text ?:@"",
                                  kCRToastNotificationTypeKey : @(CRToastTypeCustom),
                                  kCRToastNotificationPreferredHeightKey : @(44),
                                  kCRToastNotificationPreferredPaddingKey : @(10),
                                  kCRToastTextColorKey : [UIColor whiteColor],
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : __UIColorFromHexRGB(0x7F7F7F),
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                            NSLog(@"Completed");
                                    }];
}
@end
