//
//  MLSFastView.h
//  MLSProject
//
//  Created by MinLison on 2017/6/12.
//  Copyright © 2017年 com.minlison.orgz. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MLSFastView : UIView

/**
 快进视图

 @param formatTime 格式化后的时间字符串
 @param progress 进度
 @param forawrd 方向 YES快进/NO快退
 */
- (void)setFormatTime:(NSString *)formatTime progress:(CGFloat)progress forward:(BOOL)forawrd;
@end
