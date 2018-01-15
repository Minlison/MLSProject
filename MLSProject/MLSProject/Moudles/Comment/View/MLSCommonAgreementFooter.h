//
//  MLSCommonAgreementFooter.h
//  MLSProject
//
//  Created by MinLison on 2017/12/14.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseTableHeaderFooterView.h"

typedef NS_ENUM(NSInteger, LNCommonAgreementFooterActionType)
{
        LNCommonAgreementFooterAgree,
        LNCommonAgreementFooterUnAgree,
        LNCommonAgreementFooterAgreeAndShowAgreement,
};
typedef NS_ENUM(NSInteger,LNCommonAgreementFooterAlignment)
{
        LNCommonAgreementFooterAlignmentCenter,
        LNCommonAgreementFooterAlignmentLeft
};
typedef void (^LNCommonAgreementFooterActionBlock)(LNCommonAgreementFooterActionType type, BOOL isAgree);
@interface MLSCommonAgreementFooter : BaseTableHeaderFooterView
@property(nonatomic, assign) LNCommonAgreementFooterAlignment alignment;
@property(nonatomic, copy) LNCommonAgreementFooterActionBlock actionBlock;
@end
