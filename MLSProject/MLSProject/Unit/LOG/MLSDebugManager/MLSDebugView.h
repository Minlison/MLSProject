//
//  MLSDebugView.h
//  MLSLogger
//
//  Created by MinLison on 16/8/18.
//  Copyright © 2016年 MinLison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLSDebugView : UIView
- (void)showDebug;
- (void)hideDebug;
- (void)setString:(NSString *)str;
- (void)clear;
@end
