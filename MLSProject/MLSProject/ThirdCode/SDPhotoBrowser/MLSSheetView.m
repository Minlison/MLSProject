//
//  MLSSheetView.H
//  MLSProject
//
//  Created by MinLison on 2017/10/9.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSSheetView.h"

#define BTNHEIGHT 50.0f


@implementation MLSSheetView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = __MAIN_SCREEN_BOUNDS__;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        [self setUI];
        
    }
    return self;
}

-(void)setUI
{


    UIView *contentView = [[UIView alloc]init];
    
    contentView.backgroundColor = [UIColorHex(0xCDCDD1) colorWithAlphaComponent:0.8];
    
    [self addSubview:contentView];
    
    UIButton *saveBtn = [[UIButton alloc]init];
    
    saveBtn.backgroundColor = [UIColor whiteColor];
    
    saveBtn.tag = 201;
    
    [saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    saveBtn.titleLabel.font = MLSSystem16Font;
    
    saveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [contentView addSubview:saveBtn];
    
    UIButton *cancleBtn = [[UIButton alloc]init];
    
    cancleBtn.tag = 202;
    
    cancleBtn.backgroundColor = [UIColor whiteColor];
    
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    cancleBtn.titleLabel.font = MLSSystem16Font;
    
    cancleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [contentView addSubview:cancleBtn];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.leading.trailing.equalTo(contentView);
        
        make.height.offset(__MLSWidth(BTNHEIGHT));
    }];
    
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(saveBtn.mas_bottom).offset(__MLSWidth(6.0f));
        
        make.bottom.leading.trailing.equalTo(contentView);
        
        make.height.offset(__MLSWidth(BTNHEIGHT));
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.leading.trailing.equalTo(self);
        
    }];
    
    [saveBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [cancleBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)click:(UIButton *)btn
{

    switch (btn.tag) {
            
        case 201:
            
            if (self.clickBlock){
            
                self.clickBlock(MLSSheetViewClickTypeSave);
            }
            
            break;
        case 202:
            
            if (self.clickBlock){
                
                self.clickBlock(MLSSheetViewClickTypeCancle);
                    
            }
            
            break;
        default:
            break;
    }
    
    [self removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

    
}

@end
