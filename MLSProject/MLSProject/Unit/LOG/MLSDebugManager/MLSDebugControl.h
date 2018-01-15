//
//  MLSDebugControl.h
//  MLSLogger
//
//  Created by MinLison on 16/8/18.
//  Copyright © 2016年 MinLison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLSDebugControl : UIControl

+ (instancetype)debugControlWithShowDebugViewBlock:(void (^)(BOOL isShow))block;

@end
