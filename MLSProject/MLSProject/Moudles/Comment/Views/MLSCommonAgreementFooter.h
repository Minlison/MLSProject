//
//  MLSCommonAgreementFooter.h
//  MLSProject
//
//  Created by MinLison on 2017/12/14.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseTableHeaderFooterView.h"

typedef NS_ENUM(NSInteger, MLSCommonAgreementFooterActionType)
{
        MLSCommonAgreementFooterAgree,
        MLSCommonAgreementFooterUnAgree,
        MLSCommonAgreementFooterAgreeAndShowAgreement,
};
typedef NS_ENUM(NSInteger,MLSCommonAgreementFooterAlignment)
{
        MLSCommonAgreementFooterAlignmentCenter,
        MLSCommonAgreementFooterAlignmentLeft
};
typedef void (^MLSCommonAgreementFooterActionBlock)(MLSCommonAgreementFooterActionType type, BOOL isAgree);
@interface MLSCommonAgreementFooter : BaseTableHeaderFooterView
@property(nonatomic, assign) MLSCommonAgreementFooterAlignment alignment;
@property(nonatomic, copy) MLSCommonAgreementFooterActionBlock actionBlock;
@end
