//
//  MLSConfigService.h
//  MinLison
//
//  Created by MinLison on 2017/11/17.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseService.h"

@interface MLSConfigService : BaseService

/**
 服务器地址
 */
@property(class, nonatomic, copy) NSString *serverAddress;
@end
