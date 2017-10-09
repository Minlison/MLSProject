//
//  BaseNavigationBar.m
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseNavigationBar.h"

@implementation BaseNavigationBar
{
        UIImageView *_splitLine;
}

- (CGSize)sizeThatFits:(CGSize)size
{
        return CGSizeMake(self.frame.size.width, NavigationBarHeight);
}

- (id)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        
        if (self) {
                self.barStyle    = UIBarStyleDefault;
                self.translucent = YES;
                
                _splitLine = [[UIImageView alloc] init];
                _splitLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [self addSubview:_splitLine];
                self.shadowImage = [[UIImage alloc] init];
                self.backIndicatorImage = [[UIImage alloc] init];
        }
        
        return self;
}

-(void)setBottomLineColor:(UIColor *)bottomLineColor
{
        _splitLine.backgroundColor = bottomLineColor;
}

- (UIColor *)bottomLineColor
{
        return _splitLine.backgroundColor;
}

- (void)layoutSubviews
{
        [super layoutSubviews];
        
        _splitLine.frame = CGRectMake(0, self.height, self.width, 0.5f);
}


@end
