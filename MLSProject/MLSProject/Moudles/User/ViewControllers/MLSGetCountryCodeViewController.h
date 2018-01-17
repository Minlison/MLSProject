//
//  MLSGetCountryCodeViewController.h
//  MinLison
//
//  Created by MinLison on 2017/11/5.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MLSGetCountryCodeView.h"
@interface MLSGetCountryCodeViewController : BaseTableViewController <MLSGetCountryCodeView *>

/**
 选择地区编码回调

 @param action  aciton
 */
- (void)setGetCountryCodeBlock:(void (^)(NSString *countryCode))action;

@end
