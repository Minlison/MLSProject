//
//  MLSFont.h
//  MinLison
//
//  Created by MinLison on 16/9/5.
//  Copyright © 2016年 MinLison. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  正常系统字体
 */
UIFont * NormalSystemFont(CGFloat inch_3_5,
                          CGFloat inch_4_0,
                          CGFloat inch_4_7,
                          CGFloat inch_5_5,
                          CGFloat inch_5_8);

/**
 *  粗体
 */
UIFont * BoldSystemFont(CGFloat inch_3_5,
                        CGFloat inch_4_0,
                        CGFloat inch_4_7,
                        CGFloat inch_5_5,
                        CGFloat inch_5_8);


/**
 *   UI给出的适配字体
 *   系统字体
 */
#define WGSystem7Font           NormalSystemFont(7, 7, 7, 8, 8)

#define WGSystem9Font           NormalSystemFont(9, 9, 9, 10, 10)

#define WGSystem10Font          NormalSystemFont(10, 10, 10, 11, 11)

#define WGSystem11Font          NormalSystemFont(10, 10, 11, 12, 12)

#define WGSystem12Font          NormalSystemFont(12, 12, 12, 13, 13)

#define WGSystem13Font          NormalSystemFont(13, 13, 13, 14, 14)

#define WGSystem14Font          NormalSystemFont(13, 13, 14, 15, 15)

#define WGSystem15Font          NormalSystemFont(14, 14, 15, 16, 16)

#define WGSystem16Font          NormalSystemFont(16, 16, 16, 17, 17)

#define WGSystem17Font          NormalSystemFont(16, 16, 17, 18, 18)

#define WGSystem18Font          NormalSystemFont(17, 17, 18, 19, 19)

#define WGSystem19Font          NormalSystemFont(18, 18, 19, 20, 20)

#define WGSystem20Font          NormalSystemFont(19, 19, 20, 21, 21)

#define WGSystem21Font          NormalSystemFont(20, 20, 21, 22, 22)

/**
 *  系统加粗字体
 */
#define WGBoldSystem12Font      BoldSystemFont(12, 12, 12, 13, 13)
#define WGBoldSystem13Font      BoldSystemFont(13, 13, 13, 14, 14)

#define WGBoldSystem15Font      BoldSystemFont(14, 14, 15, 16, 16)
#define WGBoldSystem16Font      BoldSystemFont(15, 15, 16, 17, 17)

#define WGBoldSystem14Font          BoldSystemFont(13, 13, 14, 15, 15)

#define WGBoldSystem17Font          BoldSystemFont(16, 16, 17, 18, 18)

#define WGBoldSystem18Font          BoldSystemFont(17, 17, 18, 19, 19)
#define WGBoldSystem20Font          BoldSystemFont(19, 19, 20, 21, 21)
#define WGBoldSystem21Font          BoldSystemFont(20, 20, 21, 22, 22)




