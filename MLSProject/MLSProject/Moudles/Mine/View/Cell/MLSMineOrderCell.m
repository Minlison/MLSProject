//
//  MLSMineOrderCell.m
//  MLSProject
//
//  Created by MinLison on 2017/12/8.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSMineOrderCell.h"
@interface MLSMineOrderCell ()
@property(nonatomic, strong) QMUIGridView *gridView;
@end

@implementation MLSMineOrderCell

- (void)configure
{
        [super configure];
        self.accessoryType = UITableViewCellAccessoryNone;
//        NSArray <NSString *>*namesArray = @[@"待付款",@"已付款",@"已取消",@"已完成"];
//        NSArray <UIImage *>*imagesArray = @[[UIImage wo_de_dai_fu_kuan],[UIImage wo_de_yi_fu_kuan],[UIImage wo_de_yi_qu_xiao],[UIImage wo_de_yi_wan_cheng]];
//        @weakify(self);
//        [namesArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                QMUIButton *btn = [self createButtonForTitle:obj image:imagesArray[idx] actionBlock:^(NSInteger tag) {
//                        @strongify(self);
//                        if (self.actionBlock)
//                        {
//                                self.actionBlock(tag);
//                        }
//                        else
//                        {
//                                [MLSUserManager pushOrPresentLoginIfNeed:YES inViewController:self.formViewController completion:^{
//
//                                } dismiss:^{
//                                        [self.formViewController routeUrl:kMLSOrderControllerURI param:@{
//                                                                                                        kRequestKeyOrderStatusType : @(tag)
//                                                                                                        }];
//                                }];
//
//                        }
//                }];
//                btn.tag = idx;
//                [self.gridView addSubview:btn];
//        }];
//        [self.contentView addSubview:self.gridView];
//        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(self);
//        }];
//        [self.gridView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(self.contentView);
//        }];

}
- (void)update
{
        [super update];
}
- (QMUIGridView *)gridView
{
        if (_gridView == nil) {
                _gridView = [[QMUIGridView alloc] init];
                _gridView.separatorWidth = __WGWidth(0);
                _gridView.separatorColor = [UIColor clearColor];
                _gridView.rowHeight = __WGHeight(87);
                _gridView.columnCount = 4;
        }
        return _gridView;
}
- (QMUIButton *)createButtonForTitle:(NSString *)title image:(UIImage *)image actionBlock:(void (^)(NSInteger tag))actionBlock
{
        QMUIButton *button = [[QMUIButton alloc] init];
        [button setTitle:title forState:(UIControlStateNormal)];
        [button setImage:image forState:(UIControlStateNormal)];
        [button jk_addActionHandler:actionBlock];
        button.imagePosition = QMUIButtonImagePositionTop;
        button.spacingBetweenImageAndTitle = 8;
        [button setTitleColor:UIColorHex(0x323232) forState:(UIControlStateNormal)];
        button.titleLabel.font = WGSystem12Font;
        return button;
}
@end
