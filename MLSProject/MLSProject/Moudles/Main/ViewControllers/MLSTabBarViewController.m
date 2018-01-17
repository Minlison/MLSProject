//
//  MLSTabBarViewController.m
//  MinLison
//
//  Created by MinLison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSTabBarViewController.h"
#import "MLSTabBarViewController.h"

@interface MLSTabBarViewController ()
@property (strong, nonatomic) NSMutableDictionary <NSString *,__kindof UIViewController *>*vcStoreDict;
@end

@implementation MLSTabBarViewController

- (void)addTabBarController:(__kindof UIViewController *)vc atIndex:(NSInteger)index
{
        if (vc == nil)
        {
                return;
        }
        [self.vcStoreDict setObject:vc forKey:[NSString stringWithFormat:@"%d",(int)index]];
        [self setViewControllers:[self.vcStoreDict allValuesSortedByKeys] animated:NO];
        [self setSelectedIndex:0];
}
- (NSMutableDictionary<NSString *,UIViewController *> *)vcStoreDict
{
        if (_vcStoreDict == nil) {
                _vcStoreDict = [[NSMutableDictionary alloc] init];
        }
        return _vcStoreDict;
}
@end
