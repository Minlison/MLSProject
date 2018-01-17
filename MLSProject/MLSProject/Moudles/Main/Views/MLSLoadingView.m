//
//  MLSLoadingView.m
//  ChengziZdd
//
//  Created by chengzi on 2017/9/8.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import "MLSLoadingView.h"

@interface MLSLoadingView ()
@property (strong, nonatomic) UIImageView *imgView;
@end

@implementation MLSLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
        if (self = [super initWithFrame:frame])
        {
                
                self.backgroundColor = UIColorHex(0xF5F5F5);
                
                [self setUI];
        }
        return self;
}

-(void)setIsAnmation:(BOOL)isAnmation{

        _isAnmation = isAnmation;
        
        self.imgView.hidden = !isAnmation;
}

-(void)setUI{
        
        UIImageView *imageView = [[UIImageView alloc]init];
        
        self.imgView = imageView;
        
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.center.equalTo(self);
                
                make.width.offset(__WGWidth(50.0f));
                
                make.height.offset(__WGWidth(50.0f));
        }];
        
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (int i = 0; i<10; i++) {
                
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%05d",i]];
                
                [arr addObject:image];
        }
        
        imageView.animationImages = arr;
        
        imageView.animationRepeatCount = 0;
        
        imageView.animationDuration = 1;
        
        [imageView startAnimating];
        
}


@end
