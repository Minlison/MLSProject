//
//  MLSFont.m
//  MinLison
//
//  Created by MinLison on 16/9/5.
//  Copyright © 2016年 MinLison. All rights reserved.
//

/**
 *  自定义字体
 */

UIFont * SystemFont(BOOL isBold,
                    CGFloat inch_3_5,
                    CGFloat inch_4_0,
                    CGFloat inch_4_7,
                    CGFloat inch_5_5,
                    CGFloat inch_5_8)
{
        if ([CoBaseUtils isPhoneType:(iPhoneTypeInches_3_5)])
        {
                return isBold ? [UIFont boldSystemFontOfSize:inch_3_5] : [UIFont systemFontOfSize:inch_3_5];
        }
        else if ([CoBaseUtils isPhoneType:(iPhoneTypeInches_4_0)])
        {
                return isBold ? [UIFont boldSystemFontOfSize:inch_4_0] : [UIFont systemFontOfSize:inch_4_0];
        }
        else if ([CoBaseUtils isPhoneType:(iPhoneTypeInches_4_7)])
        {
                return isBold ? [UIFont boldSystemFontOfSize:inch_4_7] : [UIFont systemFontOfSize:inch_4_7];
        }
        else if ([CoBaseUtils isPhoneType:(iPhoneTypeInches_5_5)])
        {
                return isBold ? [UIFont boldSystemFontOfSize:inch_5_5] : [UIFont systemFontOfSize:inch_5_5];
        }
        else if ([CoBaseUtils isPhoneType:(iPhoneTypeInches_5_8)])
        {
                return isBold ? [UIFont boldSystemFontOfSize:inch_5_8] : [UIFont systemFontOfSize:inch_5_8];
        }
        return isBold ? [UIFont boldSystemFontOfSize:inch_4_7] : [UIFont systemFontOfSize:inch_4_7];
}

UIFont * NormalSystemFont(CGFloat inch_3_5,
                          CGFloat inch_4_0,
                          CGFloat inch_4_7,
                          CGFloat inch_5_5,
                          CGFloat inch_5_8)
{
        return SystemFont(NO, inch_3_5, inch_4_0, inch_4_7, inch_5_5, inch_5_8);
}

UIFont * BoldSystemFont(CGFloat inch_3_5,
                        CGFloat inch_4_0,
                        CGFloat inch_4_7,
                        CGFloat inch_5_5,
                        CGFloat inch_5_8)
{
        return SystemFont(YES, inch_3_5, inch_4_0, inch_4_7, inch_5_5, inch_5_8);
}









