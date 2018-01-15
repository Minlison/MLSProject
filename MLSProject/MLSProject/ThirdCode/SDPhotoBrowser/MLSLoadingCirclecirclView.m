//
//  MLSLoadingCirclecirclView.m
//  加载
//
//  Created by chengzi on 2017/9/10.
//  Copyright © 2017年 com.CZVRDemo. All rights reserved.
//

#import "MLSLoadingCirclecirclView.h"

@interface MLSLoadingCirclecirclView ()
//是否正在动画
@property (assign, nonatomic) BOOL isAnimating;
//动画容器
@property (strong, nonatomic) UIImageView *imageView;
//计时
@property (strong, nonatomic) CADisplayLink *displayLink;
@end

@implementation MLSLoadingCirclecirclView

- (instancetype)initWithFrame:(CGRect)frame
{
        if (self = [super initWithFrame:frame])
        {
                self.backgroundColor = [UIColor clearColor];
                
                self.imageView = [[UIImageView alloc]init];
                
                self.imageView.frame = CGRectMake(0, 0, 40, 40);
                
                self.imageView.image = [UIImage loading_pic];
                
//                self.hidden  = YES;
                
                [self addSubview:self.imageView];
  
        }
        return self;
}

-(void)layoutSubviews{

        [super layoutSubviews];
        
        self.imageView.center = CGPointMake(self.width*0.5, self.height*0.5);

}

- (void)startDisplayLink
{
        if (self.displayLink)
        {
                [self.displayLink invalidate];
                self.displayLink = nil;
        }
        self.displayLink = ({
                CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(loadingRotation)];
                [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
                link;
        });
}
- (void)endDisplayLink
{
        if (self.displayLink)
        {
                [self.displayLink invalidate];
                self.displayLink = nil;
        }
}
- (void)loadingRotation
{
        CGAffineTransform currentTransfrom = self.imageView.transform;
        self.imageView.transform = CGAffineTransformRotate(currentTransfrom,-(M_1_PI / 2.0));
}

- (void)startAnimating{
        if (self.isAnimating)
                return;
        self.hidden  = NO;
        [self startDisplayLink];
        self.isAnimating = YES;
        
}

- (void)stopAnimating {
        if (!self.isAnimating)
                return;
      
        self.isAnimating = NO;
        [self endDisplayLink];
   
        self.hidden = YES;
        
}




@end
