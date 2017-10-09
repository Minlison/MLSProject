//
//  ColorDefine.h
//  minlison
//
//  Created by MinLison on 15/12/3.
//  Copyright © 2015年 minlison. All rights reserved.
//
// 获取八进制颜色
#define __UIColorFromHexRGB(rgbValue) UIColorHex(rgbValue)

/**
 *  颜色(RGB)
 */
#define __RgbColor(r, g, b)        [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define __RgbaColor(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define __RandomColor              [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]
