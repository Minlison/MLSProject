//
//  PCCPViewController.h
//  PCCPDemo
//
//  Created by 杨建亚 on 15/5/15.
//  Copyright (c) 2015年 Dwarven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCCPViewController : UITableViewController

@property (nonatomic) BOOL isUsingChinese;
@property (nonatomic, strong) NSString * leftBarButtonItemTitle;

- (id)initWithCompletion:(void(^)(id countryDic))completion;
+ (UIImage *)imageForCountryCode:(NSString *)code;
+ (id)infoFromSimCardAndiOSSettings;
+ (id)infoForPhoneCode:(NSInteger)phoneCode;

@end
