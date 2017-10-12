//
//  BaseMoudle.h
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterceptorProtocol.h"
#import "BaseProtocol.h"
#import "EncryptTool.h"
#import "RequestUrlFilter.h"
#import "BaseRequest.h"
#import "NetworkRequest.h"
#import "SignRequest.h"
#import "BaseModel.h"
#import "BaseService.h"
#import "BaseView.h"
#import "BaseViewModel.h"
#import "BaseViewController.h"
#import "BaseNavigationViewController.h"
/**
 * 基类 Moudle
 * 每创建一个模块时, 需要继承该类, 并在Moudle 头文件中, 引入该模块的所有暴露的头文件
 * 可以使用 BH_EXPORT_MODULE(NO) 是否异步加载 Moudle (该方法是在 +load 方法内调用, 需要写到 @implementation 和 @end 之间)
 * 也可以使用 @BeeHiveMod(BaseMoudle) 来注册 Moudlle (该方法是在应用启动前, 加载符号文件时候调用)
 */

#define MOUDLE_REGISTER(moudle_imp) BeeHiveMod(moudle_imp)

#define MOUDLE_EXPORT(async) BH_EXPORT_MODULE(async)

@interface BaseMoudle : NSObject <BHModuleProtocol>

@end
