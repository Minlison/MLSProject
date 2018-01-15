//
//  BaseTableViewCell.h
//  MinLison
//
//  Created by MinLison on 2017/10/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "QMUITableViewCell.h"
#import "NimbusCollections.h"
/**
 // Do nothing
 */
@interface BaseTableViewCell : QMUITableViewCell

/**
 配置视图
 */
- (void)setupView NS_REQUIRES_SUPER; 
@end
