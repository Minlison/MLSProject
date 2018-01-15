//
//  RouterService.h
//  MinLison
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseService.h"
#import "RouterServiceProtocol.h"
@interface RouterService : BaseService<RouterServiceProtocol>
+ (instancetype)sharedInstance;
@end
