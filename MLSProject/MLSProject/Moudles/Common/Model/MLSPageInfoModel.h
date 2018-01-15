//
//  MLSPageInfoModel.h
//  MLSProject
//
//  Created by 袁航 on 2017/12/2.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseModel.h"

@interface MLSPageInfoModel : BaseModel
@property(nonatomic, copy) NSString *total;
@property(nonatomic, copy) NSString *current_page;
@property(nonatomic, copy) NSString *last_page;
@property(nonatomic, copy) NSString *list_rows;
@end
