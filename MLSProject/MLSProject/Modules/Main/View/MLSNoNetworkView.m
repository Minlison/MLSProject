//
//  MLSNoNetworkView.m
//  minlison
//
//  Created by MinLison on 15/9/16.
//  Copyright (c) 2015年 minlison. All rights reserved.
//

#import "MLSNoNetworkView.h"
@interface MLSNoNetworkView()
@end
@implementation MLSNoNetworkView
+ (instancetype)noNetworkView {
        MLSNoNetworkView *noNetView = [[self alloc] init];
        return noNetView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
        if (self = [super initWithFrame:frame])
        {
                self.frame = __MAIN_SCREEN_BOUNDS__;
                
                self.backgroundColor = UIColorHex(0xf5f5f5);
                
                [self setUI];
        }
        return self;
}

-(void)setUI{
        
        UIImageView *imageView = [[UIImageView alloc]init];
        
        imageView.image = [UIImage none_pic];
        
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self).offset(__MLSWidth(251.0f));
                
                make.centerX.equalTo(self.mas_centerX);
                
                make.width.offset(__MLSWidth(99.0f));
                
                make.height.offset(__MLSWidth(22.0f));
        }];
        
        UILabel *lab = [[UILabel alloc]init];
        
        lab.text = @"加载失败，请检查网络链接!";
        
        lab.textColor = UIColorHex(0xBFC4C6);
        
        lab.font  = MLSSystem14Font;
        
        lab.alpha = 0.6;
        
        [self addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self).offset(__MLSWidth(300.0f));
                
                make.centerX.equalTo(self.mas_centerX);
                
                make.height.offset(__MLSWidth(20.0f));
        }];
        
        UIButton *btn = [[UIButton alloc]init];
        
        btn.backgroundColor = [UIColor whiteColor];
        
        btn.layer.cornerRadius = __MLSWidth(15.0f);
        
        btn.clipsToBounds = YES;
        
        [btn setTitle:@"刷新" forState:UIControlStateNormal];
        
        btn.titleLabel.font = MLSSystem14Font;
        
        [btn setTitleColor:UIColorHex(0x626262) forState:UIControlStateNormal];
        
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(lab.mas_bottom).offset(__MLSWidth(22.0f));
                
                make.centerX.equalTo(self.mas_centerX);
                
                make.width.offset(__MLSWidth(91.0f));
                
                make.height.offset(__MLSWidth(30.0f));
        }];
        
        [btn addTarget:self action:@selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
}

- (void)setConvenienceRefreshBlock:(void (^)(void))refreshBlock {
        self.refreshBlock = refreshBlock;
}



- (void)refreshButtonClick:(UIButton *)sender {
        if (self.refreshBlock) {
                self.refreshBlock();
        }
}

@end



