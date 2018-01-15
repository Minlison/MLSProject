//
//  MLSConfigForm.h
//  MinLison
//
//  Created by MinLison on 2017/11/17.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
@interface MLSConfigForm : NSObject <FXForm>
@property(nonatomic, copy) NSString *serverAddress25;
@property(nonatomic, copy) NSString *serverAddress40;
@property(nonatomic, copy) NSString *serverAddressTest;
@property(nonatomic, copy) NSString *serverAddressPreProduct;
@property(nonatomic, copy) NSString *serverAddressOnline;
@property(nonatomic, assign) BOOL showDebugView;
@property(nonatomic, copy) NSString *logout;
@property(nonatomic, copy) NSString *clearCache;
@property(nonatomic, copy) NSString *gotoOnlineApp;
@end
