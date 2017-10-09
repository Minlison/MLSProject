//
//  BaseService.h
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVICE_REGISTER(service_protocol,service_impl) BeeHiveService(service_protocol, service_impl)

@interface BaseService : NSObject

@end
