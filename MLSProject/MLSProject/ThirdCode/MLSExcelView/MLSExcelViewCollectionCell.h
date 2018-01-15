//
//  MLSExcelViewCollectionCell.h
//  MLSExcelViewSample
//
//  Created by MinLison on 16/4/6.
//  Copyright © 2017年 yizmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "MLSExcelViewViewEnum.h"

@interface MLSExcelViewCollectionCell : UICollectionViewCell

@property (nonatomic) CGFloat textHorizontalMargin;

- (void)setAttributedString:(NSAttributedString *)attributedString;

@end
