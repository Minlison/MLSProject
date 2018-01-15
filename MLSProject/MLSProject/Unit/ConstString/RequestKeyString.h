//
//  RequestKeyString.h
//  MinLison
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 定义字符串时, 按照 kRequestKey 前缀加参数名首字母大写的命名规则
 */

#ifndef RequestKeyString_h
#define RequestKeyString_h
/// 请求参数
// MARK: - Global Params Key
FOUNDATION_EXTERN  NSString *const kRequestKeyParam;
FOUNDATION_EXTERN  NSString *const kRequestKeySign;
FOUNDATION_EXTERN  NSString *const kRequestKeyTrace_Id;

//MARK: - Defaut Pramams Key
FOUNDATION_EXTERN  NSString *const kRequestKeyApp_ID;
FOUNDATION_EXTERN  NSString *const kRequestKeyDevice_Info;
FOUNDATION_EXTERN  NSString *const kRequestKeyMethod;
FOUNDATION_EXTERN  NSString *const kRequestKeyMethodVersion;
FOUNDATION_EXTERN  NSString *const kRequestKeyNetType;
FOUNDATION_EXTERN  NSString *const kRequestKeyUUID;
FOUNDATION_EXTERN  NSString *const kRequestKeySys_Type;
FOUNDATION_EXTERN  NSString *const kRequestKeyApp_Version_Code;
FOUNDATION_EXTERN  NSString *const kRequestKeyPage;
FOUNDATION_EXTERN  NSString *const kRequestKeyStart_Position;
FOUNDATION_EXTERN  NSString *const kRequestKeyID;
FOUNDATION_EXTERN  NSString *const kRequestKeyPackage_Name;
FOUNDATION_EXTERN  NSString *const kRequestKeyVersion_Code;
/// MARK: = User
FOUNDATION_EXTERN  NSString *const kRequestKeyType;
FOUNDATION_EXTERN NSString *const kRequestKeyPassword;
FOUNDATION_EXTERN  NSString *const kRequestKeyThird_Party_Id;
FOUNDATION_EXTERN  NSString *const kRequestKeyNick_Name;
FOUNDATION_EXTERN  NSString *const kRequestKeyAvatar;
FOUNDATION_EXTERN  NSString *const kRequestKeyCountry_Code;
FOUNDATION_EXTERN  NSString *const kRequestKeyPhone;
FOUNDATION_EXTERN  NSString *const kRequestKeyMobile;
FOUNDATION_EXTERN  NSString *const kRequestKeySms_Code;
FOUNDATION_EXTERN  NSString *const kRequestKeyUser_ID;
FOUNDATION_EXTERN  NSString *const kRequestKeyToken;
FOUNDATION_EXTERN  NSString *const kRequestKeyRefresh_Token;
FOUNDATION_EXTERN  NSString *const kRequestKeyUpload_Type;
FOUNDATION_EXTERN  NSString *const kRequestKeyImg;
FOUNDATION_EXTERN  NSString *const kRequestKeyList_Type;
FOUNDATION_EXTERN  NSString *const kRequestKeyItem_Id;
FOUNDATION_EXTERN  NSString *const kRequestKeyPid;
FOUNDATION_EXTERN  NSString *const kRequestKeyContent;
FOUNDATION_EXTERN  NSString *const kRequestKeyStatus;
FOUNDATION_EXTERN  NSString *const kRequestKeyItem_Ids;
FOUNDATION_EXTERN  NSString *const kRequestKeyTime;
FOUNDATION_EXTERN  NSString *const kRequestKeyLat;
FOUNDATION_EXTERN  NSString *const kRequestKeyLng;
FOUNDATION_EXTERN  NSString *const kRequestKeyAreaID;
FOUNDATION_EXTERN  NSString *const kRequestKeySportId;
FOUNDATION_EXTERN  NSString *const kRequestKeyLimit;
FOUNDATION_EXTERN  NSString *const kRequestKeyName;
FOUNDATION_EXTERN  NSString *const kRequestKeyTitle;
FOUNDATION_EXTERN  NSString *const kRequestKeyUrl;
FOUNDATION_EXTERN  NSString *const kRequestKeyCardID;
FOUNDATION_EXTERN  NSString *const kRequestKeyCardNum;
FOUNDATION_EXTERN  NSString *const kRequestKeyCardPassword;
FOUNDATION_EXTERN  NSString *const kRequestKeyCardOldPassword;
FOUNDATION_EXTERN  NSString *const kRequestKeyCardNewPassword;
FOUNDATION_EXTERN  NSString *const kRequestKeyOrderType;
FOUNDATION_EXTERN  NSString *const kRequestKeyOrderStatusType;
FOUNDATION_EXTERN  NSString *const kRequestKeyArticleType;
FOUNDATION_EXTERN  NSString *const kRequestKeyArticleID;
FOUNDATION_EXTERN  NSString *const kRequestKeyActivityItemId;
FOUNDATION_EXTERN  NSString *const kRequestKeyActivitySubscribId;
FOUNDATION_EXTERN  NSString *const kRequestKeyNum;
FOUNDATION_EXTERN  NSString *const kRequestKeyCateID;
FOUNDATION_EXTERN  NSString *const kRequestKeyClassTypeID;
#endif
