//
//  TLMenuButton.m
//  MiShu
//
//  Created by tianlei on 16/6/21.
//  Copyright © 2016年 Qzy. All rights reserved.
//

#import "MLSMenuButton.h"

@implementation MLSMenuButton
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(20.5, 8, 14, 16);
//}
//
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(0,26, self.bounds.size.width, 20);
//}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

+ (instancetype)buttonWithTitle:(NSString *)title imageTitle:(NSString *)imageTitle color:(UIColor *)color
{
    MLSMenuButton *menu4 = [[MLSMenuButton alloc] initWithFrame:CGRectZero];
    menu4.backgroundColor = color;
    [menu4 setTitle:title forState:UIControlStateNormal];
    [menu4 setImage:[UIImage imageNamed:imageTitle] forState:UIControlStateNormal];
    return menu4;
}
@end
