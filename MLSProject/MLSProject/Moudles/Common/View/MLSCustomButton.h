//
//  MLSCustomButton.h
//  ChengziZdd
//
//  Created by chengzi on 2017/9/6.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLSCustomButton : QMUIButton
+(instancetype)leftImgButton;
+(instancetype)rightImgButton;
+(instancetype)rightImgButtonWithBorderColor:(UIColor *)borderColor textColor:(UIColor *)textColor;
@end
