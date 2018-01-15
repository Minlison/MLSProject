//
//  MLSUserTableHeaderView.h
//  MinLison
//
//  Created by MinLison on 2017/10/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface MLSUserTableHeaderView : BaseView
/**
 头像点击
 
 @param clickBlock 头像点击
 */
- (void)setUserHeadClickBlock:(void (^)(void))clickBlock;
@end
