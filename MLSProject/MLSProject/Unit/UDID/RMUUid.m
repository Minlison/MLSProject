//
//  RMUUid.m
//  WxbClient
//
//  Created by Sally Sun on 13-7-10.
//  Copyright (c) 2013年 Run Mobile. All rights reserved.
//

#import "RMUUid.h"
#define NEW_UUID_KEY    @"MF_WEIGUAN_DEVELOP_UUID_KEY"
#define kUUIDKeyChainSever  @"kWeiGuanUUIDKeyChainSever"
#define kUUIDKeyChainAccount @"kWeiGuanUUIDKeyChainAccount"

@interface RMUUid()
@property (nonatomic, retain) NSString *uuid;
@end

@implementation RMUUid

- (id)init {
        self = [super init];
        if (self)
        {
                _uuid = NULL;
                return self;
        }
        
        return nil;
}

+ (RMUUid *)_instance {
        static RMUUid * obj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		obj = [[self alloc] init];
	});
        return obj;
}
+ ( NSString *)getUTDID
{
        
        if (nil != [[RMUUid _instance] uuid] || 36 <= [[[RMUUid _instance] uuid] length])
        {
                return [[self _instance] uuid];
        }
        
        [[RMUUid _instance] setUuid:[UTDevice utdid]];
        
        return [[RMUUid _instance] uuid];
        
        //        // 增加钥匙串访问,防止用户删除应用后重新生成UUID
        //        NSString *UUID = [SAMKeychain passwordForService:kUUIDKeyChainSever account:kUUIDKeyChainAccount];
        //        if (UUID != nil && ![UUID isEqualToString:@""]) {
        //                return UUID;
        //        }
        //        NSUserDefaults *handler = [NSUserDefaults standardUserDefaults];
        //        [[RMUUid _instance] setUuid:[NSString stringWithFormat:@"%@", [handler objectForKey:NEW_UUID_KEY]]];
        //
        //        if (NULL == [[RMUUid _instance] uuid] || 36 > [[[RMUUid _instance] uuid] length])
        //        {
        //
        //                CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        //                CFStringRef uuidStr = CFUUIDCreateString(NULL, uuidRef);
        //
        //                NSString *result = [NSString stringWithFormat:@"%@", uuidStr];
        //
        //                CFRelease(uuidStr);
        //                CFRelease(uuidRef);
        //
        //                [[RMUUid _instance] setUuid:result];
        //
        //                [handler setObject:[[RMUUid _instance] uuid] forKey:NEW_UUID_KEY];
        //                [handler synchronize];
        //        }
        //        if (![SAMKeychain setPassword:[[RMUUid _instance] uuid] forService:kUUIDKeyChainSever account:kUUIDKeyChainAccount])
        //        {
        //                NSLog(@"钥匙串保存UUID失败");
        //        }
        //        return [[RMUUid _instance] uuid];
}
+ (NSString *)getUUid
{
        NSString* uuid = [RMUUid getUTDID];
        return [uuid md5String];
}

@end
