//
//  MLSSheetView.H
//  MLSProject
//
//  Created by MinLison on 2017/10/9.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger,MLSSheetViewClickType){

        MLSSheetViewClickTypeSave = 0, //保存
        
        MLSSheetViewClickTypeCollectionPhotos,//收藏组图
        
        MLSSheetViewClickTypeCancle,//取消

};

@interface MLSSheetView : UIView
@property (copy, nonatomic) void (^clickBlock)(MLSSheetViewClickType type);
@end
