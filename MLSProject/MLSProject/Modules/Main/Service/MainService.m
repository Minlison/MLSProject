//
//  MainService.m
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MainService.h"
#import "MainViewController.h"

@SERVICE_REGISTER(MainServiceProtocol, MainService)

@interface MainService ()
@property(nonatomic, strong) MainViewController *mainViewController;
@property (strong, nonatomic) NSMutableDictionary <NSString *,__kindof UIViewController *>*vcStoreDict;
@end

@implementation MainService
- (instancetype)init
{
        if (self = [super init]){
                self.vcStoreDict = [[NSMutableDictionary alloc] init];
        }
        return self;
}
- (UIViewController *)getController
{
        return self.mainViewController;
}

+ (BOOL)singleton
{
        return YES;
}
+ (id)sharedInstance {
        static dispatch_once_t onceToken;
        static MainService *instance = nil;
        dispatch_once(&onceToken,^{
                instance = [[self alloc] init];
        });
        return instance;
}

- (void)addController:(__kindof UIViewController *)vc atIndex:(NSInteger)index
{
        if (vc == nil)
        {
                return;
        }
        [self.vcStoreDict setObject:vc forKey:[NSString stringWithFormat:@"%d",(int)index]];
        self.mainViewController.viewControllers = [[self.vcStoreDict allValues] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (MainViewController *)mainViewController
{
        if (_mainViewController == nil) {
                _mainViewController = [[MainViewController alloc] init];
        }
        return _mainViewController;
}
@end
