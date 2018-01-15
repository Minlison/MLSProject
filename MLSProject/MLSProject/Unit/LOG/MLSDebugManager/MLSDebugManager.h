//
//  MLSDebugManager.h
//  MLSDebugManager
//
//  Created by MinLison on 16/8/18.
//  Copyright © 2016年 MinLison. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<MLSDebugManager/MLSDebugManager.h>)
FOUNDATION_EXPORT double MLSDebugManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char MLSDebugManagerVersionString[];
#import <MLSDebugManager/MLSDebugInstance.h>
#import <MLSDebugManager/MLSLog.h>
#else
#import "MLSDebugInstance.h"
#import "MLSLog.h"
#endif


#ifdef USE_MLSLOG
#define NSLog(fmt, ...) MLSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif



