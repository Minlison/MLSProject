//
//  MLSUserWebCatLoginCell.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUserWebCatLoginCell.h"
@interface MLSUserWebCatLoginCell ()
@property(nonatomic, strong) QMUIGhostButton *loginButton;
@end
@implementation MLSUserWebCatLoginCell


+ (CGFloat)heightForField:(FXFormField *)field width:(CGFloat)width
{
        return __WGHeight(50);
}
- (void)didSelectWithTableView:(UITableView *)tableView controller:(UIViewController *)controller
{
        // do nothing
}
- (void)setUp
{
        [super setUp];
        [self.button setImage:[UIImage project_btn_wechat] forState:(UIControlStateNormal)];
        self.button.backgroundColor = UIColorHex(0x2FB244);
}

@end
