//
//  MLSPgyerUpdateModel.h
//  MinLison
//
//  Created by MinLison on 2017/11/20.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUpdateEnum.h"
#if WGEnablePgyerSDK

#import "BaseModel.h"

@interface MLSPgyerUpdateModel : BaseModel

@property(nonatomic, copy) NSString *buildKey;
@property(nonatomic, copy) NSString *buildType;
@property(nonatomic, copy) NSString *buildIsFirst;
@property(nonatomic, copy) NSString *buildIsLastest;
@property(nonatomic, copy) NSString *buildFileSize;
@property(nonatomic, copy) NSString *buildName;
@property(nonatomic, copy) NSString *buildVersion;
@property(nonatomic, copy) NSString *buildVersionNo;
@property(nonatomic, copy) NSString *buildBuildVersion;
@property(nonatomic, copy) NSString *buildIdentifier;
@property(nonatomic, copy) NSString *buildIcon;
@property(nonatomic, copy) NSString *buildDescription;
@property(nonatomic, copy) NSString *buildUpdateDescription;
@property(nonatomic, copy) NSString *buildScreenShots;
@property(nonatomic, copy) NSString *buildShortcutUrl;
@property(nonatomic, copy) NSString *buildQRCodeURL;
@property(nonatomic, copy) NSString *buildCreated;
@property(nonatomic, copy) NSString *buildUpdated;
@property(nonatomic, copy) NSArray <MLSPgyerUpdateModel *> *otherApps;
@property(nonatomic, copy) NSString *otherAppsCount;
@property(nonatomic, copy, readonly) NSString *buildDonwloadUrl;
@end

#endif
