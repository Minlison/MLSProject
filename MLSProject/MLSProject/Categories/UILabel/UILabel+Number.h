//
//  UILabel+Number.h
//  MinLison
//
//  Created by qcm on 17/3/3.
//  Copyright © 2017年 MinLison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Number)

- (CGFloat)numberOfText;
- (BOOL)needExpend;
- (BOOL)needExpendWithLineNumbers:(int)number;
@end
