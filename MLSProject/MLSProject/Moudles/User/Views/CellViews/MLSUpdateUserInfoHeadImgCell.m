//
//  MLSUpdateUserInfoHeadImgCell.m
//  MLSProject
//
//  Created by 袁航 on 2017/12/9.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUpdateUserInfoHeadImgCell.h"
#import "MLSImagePickerViewController.h"
#import "MLSUploadImageRequest.h"
#import "MLSUpdateUserInfoRequest.h"
@interface MLSUpdateUserInfoHeadImgCell ()
@property(nonatomic, strong) MLSUploadImageRequest *uploadImgRequest;
@property(nonatomic, strong) TTTAttributedLabel *titleLabel;
@property(nonatomic, strong) QMUIGhostButton *headImgBtn;
@property(nonatomic, strong) MLSUpdateUserInfoRequest *updateUserInfoRequest;
@end

@implementation MLSUpdateUserInfoHeadImgCell
- (void)configure
{
        [super configure];
        self.accessoryType = UITableViewCellAccessoryNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.headImgBtn];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(__WGWidth(11));
        }];
        [self.headImgBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-__WGWidth(15));
                make.width.height.mas_equalTo(__WGHeight(51));
                make.top.equalTo(self.contentView).offset(__WGHeight(10));
                make.bottom.equalTo(self.contentView).offset(-__WGHeight(10));
        }];
        UIView *lineView = [[UIView alloc] init];
        [self.contentView addSubview:lineView];
        lineView.backgroundColor = UIColorHex(0xE6E6E6);
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self.contentView);
                make.height.mas_equalTo(1);
        }];
        
}
- (void)update
{
        [super update];
        [self.headImgBtn sd_setImageWithURL:[NSURL URLWithString:NOT_NULL_STRING_DEFAULT_EMPTY(self.rowDescriptor.value)] forState:(UIControlStateNormal) placeholderImage:[UIImage pic_default_avatar]];
        self.titleLabel.text = self.rowDescriptor.title;
}
- (void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
        [MLSImagePickerViewController show:(LNImagePickerTypeTakePhoto | LNImagePickerTypeChoseImage) inController:controller editImage:nil success:^(NSURL * _Nullable localImgUrl, UIImage * _Nullable image) {
                [self uploadImageFileUrl:localImgUrl image:image];
        } failed:^(NSError * _Nonnull error) {
                [MLSTipClass showText:error.localizedDescription];
        }];
}
- (void)uploadImageFileUrl:(NSURL *)url image:(UIImage *)image
{
        @weakify(self);
        [self.headImgBtn setImage:image forState:(UIControlStateNormal)];
        self.formViewController.fd_interactivePopDisabled = YES;
        [MLSTipClass showLoadingInView:self.formViewController.view];
        
        [LNUserManager uploadUserHeadFileUrl:url completion:^(MLSUserModel * _Nonnull user) {
                @strongify(self);
                self.formViewController.fd_interactivePopDisabled = NO;
                self.rowDescriptor.value = user.img;
                [self update];
                [MLSTipClass showText:[NSString stringWithFormat:@"%@修改成功",self.rowDescriptor.title] inView:self.formViewController.view];
        } failed:^(NSError * _Nonnull error) {
                @strongify(self);
                [MLSTipClass showText:error.localizedDescription inView:self.formViewController.view];
                self.formViewController.fd_interactivePopDisabled = NO;
        }];
}


- (TTTAttributedLabel *)titleLabel
{
        if ( _titleLabel == nil )
        {
                _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _titleLabel.font = WGSystem16Font;
                _titleLabel.textColor = UIColorHex(0x323232);
        }
        return _titleLabel;
}
- (QMUIGhostButton *)headImgBtn
{
        if ( _headImgBtn == nil )
        {
                _headImgBtn = [[QMUIGhostButton alloc] init];
                _headImgBtn.ghostColor = [UIColor clearColor];
                _headImgBtn.clipsToBounds = YES;
                _headImgBtn.userInteractionEnabled = NO;
        }
        return _headImgBtn;
}
@end
