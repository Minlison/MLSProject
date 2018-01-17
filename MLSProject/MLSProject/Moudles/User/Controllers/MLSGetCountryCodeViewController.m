//
//  WGUserGetCountryCodeViewController.m
//  MinLison
//
//  Created by MinLison on 2017/11/5.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSGetCountryCodeViewController.h"
#import "MLSGetCountryCodeCell.h"
#import "MLSCountryCodeManager.h"
@interface MLSGetCountryCodeViewController ()
@property(nonatomic, copy) void (^getCountryCodeActionBlock)(NSString *countryCoe);
@end

@implementation MLSGetCountryCodeViewController

- (void)viewDidLoad
{
        [super viewDidLoad];
        [self loadData];
}
- (void)setGetCountryCodeBlock:(void (^)(NSString *countryCode))action
{
        self.getCountryCodeActionBlock = action;
}
- (void)configNimbus
{
        [super configNimbus];
        [self.tableViewActions attachToClass:[WGCountryCodeModel class] tapBlock:^BOOL(WGCountryCodeModel *object, MLSGetCountryCodeViewController *target, NSIndexPath *indexPath) {
                MLSUserManager.country_code = object.phone_code;
                if (target.getCountryCodeActionBlock) {
                        target.getCountryCodeActionBlock(object.phone_code);
                }
                [target backButtonDidClick:nil];
                return YES;
        }];
}
- (void)loadData
{
        [self configNimbus];
        NSDictionary<NSString *,NSArray<WGCountryCodeModel *> *> *models = [MLSCountryCodeManager getDefaultCountryCodes];
        [models enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray<WGCountryCodeModel *> * _Nonnull obj, BOOL * _Nonnull stop) {
                [self.tableViewModel addObjectsFromArray:obj];
        }];
        [self.tableView reloadData];
}

@end
