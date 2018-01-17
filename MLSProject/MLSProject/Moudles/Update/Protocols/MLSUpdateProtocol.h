//
//  MLSUpdateProtocol.h
//  MinLison
//
//  Created by MinLison on 2017/10/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef MLSUpdateProtocol_h
#define MLSUpdateProtocol_h
#import "BaseServiceProtocol.h"
#import "MLSUpdateEnum.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MLSUpdateProtocol <BaseServiceProtocol>

/**
 显示升级控制器
 
 @param vc 在哪个控制器里显示
 @param completion 完成回调
 */
- (void)showInViewController:(UIViewController *)vc completion:(nullable WGUpdateActionBlock)completion;

/**
 检测是否有更新
 */
- (void)checkUpdate;
@end
NS_ASSUME_NONNULL_END
#endif /* MLSUpdateProtocol_h */
