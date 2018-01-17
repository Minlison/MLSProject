//
//  MLSMineOrderCell.h
//  MLSProject
//
//  Created by MinLison on 2017/12/8.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef NS_ENUM(NSInteger,MLSMineOrderCellClickType)
{
        MLSMineOrderCellClickTypeWaitingPay,
        MLSMineOrderCellClickTypePayed,
        MLSMineOrderCellClickTypeCanceled,
        MLSMineOrderCellClickTypeComplete,
};

typedef void (^MLSMineOrderCellClickBlock)(MLSMineOrderCellClickType clickType);

@interface MLSMineOrderCell : XLFormBaseCell

/**
 事件回调
 */
@property(nonatomic, copy) MLSMineOrderCellClickBlock actionBlock;
@end
