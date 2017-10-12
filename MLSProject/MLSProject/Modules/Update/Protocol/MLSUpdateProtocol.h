//
//  MLSUpdateProtocol.h
//  MLSProject
//
//  Created by MinLison on 2017/10/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef MLSUpdateProtocol_h
#define MLSUpdateProtocol_h
#import "BaseProtocol.h"
#import "MLSUpdateEnum.h"
#import <STPopup/STPopup.h>
NS_ASSUME_NONNULL_BEGIN
@protocol MLSUpdateProtocol <BaseProtocol>

/**
 显示升级控制器
 
 @param vc 在哪个控制器里显示
 @param completion 完成回调
 */
- (void)showInViewController:(UIViewController *)vc completion:(nullable MLSUpdateActionBlock)completion;
@end
NS_ASSUME_NONNULL_END
#endif /* MLSUpdateProtocol_h */
