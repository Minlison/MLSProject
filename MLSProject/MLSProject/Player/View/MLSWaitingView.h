//
//  MLSWaitingView.h
//  Test
//
//  Created by MinLison on 2017/3/7.
//  Copyright © 2017年 com.minlison.orgz. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MLSWaitingView : UIView

/**
 视频名称
 */
@property (copy, nonatomic) NSString *video_name;

/**
 旋转
 */
- (void)rotate;

/**
 快速创建实例

 @return 
 */
+ (instancetype)waitingView;
@end
