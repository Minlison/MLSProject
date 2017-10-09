//
//  MLSFont.h
//  minlison
//
//  Created by minlison on 16/9/5.
//  Copyright © 2016年 minlison. All rights reserved.
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
#define MLSSystem9Font           NormalSystemFont(9, 9, 9, 10, 10)

#define MLSSystem10Font          NormalSystemFont(10, 10, 10, 11, 11)

#define MLSSystem11Font          NormalSystemFont(10, 10, 11, 12, 12)

#define MLSSystem12Font          NormalSystemFont(12, 12, 12, 13, 13)

#define MLSSystem13Font          NormalSystemFont(13, 13, 13, 14, 14)

#define MLSSystem14Font          NormalSystemFont(13, 13, 14, 15, 15)

#define MLSSystem15Font          NormalSystemFont(14, 14, 15, 16, 16)

#define MLSSystem16Font          NormalSystemFont(16, 16, 16, 17, 17)

#define MLSSystem17Font          NormalSystemFont(16, 16, 17, 18, 18)

#define MLSSystem18Font          NormalSystemFont(17, 17, 18, 19, 19)

#define MLSSystem19Font          NormalSystemFont(18, 18, 19, 20, 20)

#define MLSSystem20Font          NormalSystemFont(19, 19, 19, 21, 21)


/** 
 *  系统加粗字体
 */
#define MLSBoldSystem13Font      BoldSystemFont(12, 12, 12, 13, 13)

#define MLSBoldSystem15Font      BoldSystemFont(14, 14, 15, 16, 16)









