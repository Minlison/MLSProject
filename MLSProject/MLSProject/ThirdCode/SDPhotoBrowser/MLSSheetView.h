//
//  MLSSheetView.h
//  newDemo
//
//  Created by minlison on 2017/9/4.
//  Copyright © 2017年 com.CZVRDemo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger,CZSheetViewClickType){

        CZSheetViewClickTypeSave = 0, //保存
        
        CZSheetViewClickTypeCollectionPhotos,//收藏组图
        
        CZSheetViewClickTypeCancle,//取消

};

@interface MLSSheetView : UIView
@property (copy, nonatomic) void (^clickBlock)(CZSheetViewClickType type);
@end
