//
//  CZColorDefine.h
//  MinLison
//
//  Created by MinLison on 15/12/3.
//  Copyright © 2015年 MinLison. All rights reserved.
//
// 获取八进制颜色
#define __UIColorFromHexRGB(rgbValue) UIColorHex(rgbValue)
#define __UIColorFromHexRGBA(hex,a) [UIColor colorWithRed:((hex >> 16) & 0xFF)/255.0 green:((hex >> 8) & 0xFF)/255.0 blue:(hex & 0xFF)/255.0 alpha:a];
/**
 *  颜色(RGB)
 */
#define __RgbColor(r, g, b)        [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define __RgbaColor(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define __RandomColor              [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]

//loading的文字颜色
#define __LOADING_TEXT_COLOR__           0xFF9F38
// 黑色
#define __BLACK_COLOR__                  0x373737
// 灰色
#define __GRAY_COLOR__                   0x7F7F7F
// 部分控件背景色
#define __VIEW_BACK_GRAY_COLOR__         0xF2F2F2
// 浅灰色
#define __LIGHT_GRAY_COLOR__             0xB8B8B8
#define __LIGHT_BLACK_COLOR__            0x666666
//分割线颜色
#define __SEGMENT_LINE_COLOR__           0xEFEFEF
