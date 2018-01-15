//
//  MLSMineOrderCell.h
//  MLSProject
//
//  Created by MinLison on 2017/12/8.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef NS_ENUM(NSInteger,LNMineOrderCellClickType)
{
        LNMineOrderCellClickTypeWaitingPay,
        LNMineOrderCellClickTypePayed,
        LNMineOrderCellClickTypeCanceled,
        LNMineOrderCellClickTypeComplete,
};

typedef void (^LNMineOrderCellClickBlock)(LNMineOrderCellClickType clickType);

@interface MLSMineOrderCell : XLFormBaseCell

/**
 事件回调
 */
@property(nonatomic, copy) LNMineOrderCellClickBlock actionBlock;
@end
