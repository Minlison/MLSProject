//
//  MLSCustomButton.m
//  ChengziZdd
//
//  Created by chengzi on 2017/9/6.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import "MLSCustomButton.h"

@implementation MLSCustomButton

+ (instancetype)leftImgButton
{
        MLSCustomButton *btn = [[self alloc]init];
        btn.imagePosition =  QMUIButtonImagePositionLeft;
        return btn;
}
+ (instancetype)rightImgButton
{
        MLSCustomButton *btn = [[self alloc]init];
        btn.imagePosition =  QMUIButtonImagePositionRight;
        return btn;
}

+(instancetype)rightImgButtonWithBorderColor:(UIColor *)borderColor textColor:(UIColor *)textColor
{
        MLSCustomButton *btn = [[self alloc]init];
        btn.layer.cornerRadius = __WGWidth(14.0f);
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = WGSystem13Font;
        [btn setTitleColor:textColor forState:UIControlStateNormal];
        [btn setHighlightedBorderColor:borderColor];
        btn.layer.borderColor = borderColor.CGColor;
        btn.layer.borderWidth = 1.0f;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        btn.imagePosition =  QMUIButtonImagePositionRight;
        return btn;
}
- (void)layoutSubviews
{
        [super layoutSubviews];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        if (self.imageView.image)
        {
                CGPoint center = self.imageView.center;
                self.imageView.size = CGSizeMake(self.height*0.5, self.height*0.5);
                self.imageView.center  = center;
        }
}

@end
