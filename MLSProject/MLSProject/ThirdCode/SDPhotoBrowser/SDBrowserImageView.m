//
//  SDBrowserImageView.m
//  SDPhotoBrowser
//
//  Created by aier on 15-2-6.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDBrowserImageView.h"
#import "SDPhotoBrowserConfig.h"
#import "MLSLoadingCirclecirclView.h"

@implementation SDBrowserImageView
{
        MLSLoadingCirclecirclView *_waitingView;
        
        //        __weak SDWaitingView *_waitingView;//进度绘图缓冲
        BOOL _didCheckSize;
        UIScrollView *_scroll;
        YYAnimatedImageView *_scrollImageView;
        UIScrollView *_zoomingScroolView;
        YYAnimatedImageView *_zoomingImageView;
        CGFloat _totalScale;
}


- (id)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.userInteractionEnabled = YES;
                self.contentMode = UIViewContentModeScaleAspectFit;
                _totalScale = 1.0;
                
                // 捏合手势缩放图片
                UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage:)];
                pinch.delegate = self;
                [self addGestureRecognizer:pinch];
                
        }
        return self;
}

- (BOOL)isScaled
{
        return  1.0 != _totalScale;
}

- (void)layoutSubviews
{
        [super layoutSubviews];
        _waitingView.center = CGPointMake(__MAIN_SCREEN_WIDTH__*0.5, self.frame.size.height * 0.5);
        
        CGSize imageSize = self.image.size;
        
        if (self.bounds.size.width * (imageSize.height / imageSize.width) > self.bounds.size.height) {
                if (!_scroll) {
                        UIScrollView *scroll = [[UIScrollView alloc] init];
                        scroll.backgroundColor = [UIColor whiteColor];
                        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
                        imageView.image = self.image;
                        _scrollImageView = imageView;
                        [scroll addSubview:imageView];
                        scroll.backgroundColor = SDPhotoBrowserBackgrounColor;
                        _scroll = scroll;
                        [self addSubview:scroll];
                        if (_waitingView) {
                                [self bringSubviewToFront:_waitingView];
                        }
                }
                _scroll.frame = self.bounds;
                
                CGFloat imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
                
                _scrollImageView.bounds = CGRectMake(0, 0, _scroll.frame.size.width, imageViewH);
                _scrollImageView.center = CGPointMake(_scroll.frame.size.width * 0.5, _scrollImageView.frame.size.height * 0.5);
                _scroll.contentSize = CGSizeMake(0, _scrollImageView.bounds.size.height);
                _scroll.showsHorizontalScrollIndicator = NO;
                _scroll.showsVerticalScrollIndicator = NO;
                
        } else {
                if (_scroll) [_scroll removeFromSuperview]; // 防止旋转时适配的scrollView的影响
        }
        
}

- (void)setProgress:(CGFloat)progress
{
        _progress = progress;
        //        _waitingView.progress = progress;//进度绘图缓冲
        
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
        
        //进度绘图缓冲
        //        SDWaitingView *waiting = [[SDWaitingView alloc] init];
        //        waiting.bounds = CGRectMake(0, 0, 50, 50);
        //        waiting.mode = SDWaitingViewProgressMode;
        //        _waitingView = waiting;
        //        [self addSubview:waiting];
        
        //图片圆圈加载
        MLSLoadingCirclecirclView *waiting = [[MLSLoadingCirclecirclView alloc]init];
        
        waiting.frame = CGRectMake(0, 0, 50, 50);
        
        _waitingView = waiting;
        
        [self addSubview:waiting];
        
        __weak SDBrowserImageView *imageViewWeak = self;
        
        __weak typeof(self) weakSelf = self;
        
        [imageViewWeak addWaitingView];
        
        [self setImageWithURL:url placeholder:placeholder options:YYWebImageOptionIgnoreFailedURL progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                //                weakSelf.progress = (CGFloat)receivedSize / expectedSize;//进度绘图缓冲
                
        } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                
                [imageViewWeak removeWaitingView];
                if (error) {
                        UIImageView *imgView = [[UIImageView alloc] init];
                        imgView.bounds = CGRectMake(0, 0, 105, 80);
                        imgView.image = [UIImage selectionHolder];
                        imgView.center = CGPointMake(imageViewWeak.bounds.size.width * 0.5, imageViewWeak.bounds.size.height * 0.5);
                        [imageViewWeak addSubview:imgView];
                } else {
                        weakSelf.image = image;
                }
        }];
}

- (void)zoomImage:(UIPinchGestureRecognizer *)recognizer
{
        [self prepareForImageViewScaling];
        CGFloat scale = recognizer.scale;
        CGFloat temp = _totalScale + (scale - 1);
        
        switch (recognizer.state) {
                case UIGestureRecognizerStateBegan:
                        
                        break;
                case UIGestureRecognizerStateChanged:
                        [self setTotalScale:temp];
                        break;
                case UIGestureRecognizerStateEnded:
                        if (temp<1.0){
                                
                                [self setTotalScale:1];
                                
                                [self eliminateScale];
                        }
                        break;
                default:
                        break;
        }
        
        recognizer.scale = 1.0;
        
}

- (void)setTotalScale:(CGFloat)totalScale
{
        if ((_totalScale < 0.5 && totalScale < _totalScale) || (_totalScale > 3.0 && totalScale > _totalScale)) return; // 最大缩放 3倍,最小0.5倍
        
        [self zoomWithScale:totalScale];
}

- (void)zoomWithScale:(CGFloat)scale
{
        _totalScale = scale;
        
        _zoomingImageView.transform = CGAffineTransformMakeScale(scale, scale);
        
        if (scale > 1) {
                CGFloat contentW = _zoomingImageView.frame.size.width;
                CGFloat contentH = MAX(_zoomingImageView.frame.size.height, self.frame.size.height);
                
                _zoomingImageView.center = CGPointMake(contentW * 0.5, contentH * 0.5);
                _zoomingScroolView.contentSize = CGSizeMake(contentW, contentH);
                
                
                CGPoint offset = _zoomingScroolView.contentOffset;
                offset.x = (contentW - _zoomingScroolView.frame.size.width) * 0.5;
                //        offset.y = (contentH - _zoomingImageView.frame.size.height) * 0.5;
                _zoomingScroolView.contentOffset = offset;
                
        }
        else {
                _zoomingScroolView.contentSize = _zoomingScroolView.frame.size;
                _zoomingScroolView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                _zoomingImageView.center = _zoomingScroolView.center;
                
        }
}

- (void)doubleTapToZommWithScale:(CGFloat)scale
{
        [self prepareForImageViewScaling];
        [UIView animateWithDuration:0.5 animations:^{
                [self zoomWithScale:scale];
        } completion:^(BOOL finished) {
                if (scale == 1) {
                        [self clear];
                }
        }];
}

- (void)prepareForImageViewScaling
{
        if (!_zoomingScroolView) {
                _zoomingScroolView = [[UIScrollView alloc] initWithFrame:self.bounds];
                _zoomingScroolView.backgroundColor = SDPhotoBrowserBackgrounColor;
                _zoomingScroolView.contentSize = self.bounds.size;
                _zoomingScroolView.showsVerticalScrollIndicator = NO;
                _zoomingScroolView.showsHorizontalScrollIndicator = NO;
                YYAnimatedImageView *zoomingImageView = [[YYAnimatedImageView alloc] initWithImage:self.image];
                CGSize imageSize = zoomingImageView.image.size;
                CGFloat imageViewH = self.bounds.size.height;
                if (imageSize.width > 0) {
                        imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
                }
                zoomingImageView.bounds = CGRectMake(0, 0, self.bounds.size.width, imageViewH);
                zoomingImageView.center = _zoomingScroolView.center;
                zoomingImageView.contentMode = UIViewContentModeScaleAspectFit;
                _zoomingImageView = zoomingImageView;
                [_zoomingScroolView addSubview:zoomingImageView];
                [self addSubview:_zoomingScroolView];
        }
}

- (void)scaleImage:(CGFloat)scale
{
        [self prepareForImageViewScaling];
        
        [self setTotalScale:scale];
}

// 清除缩放
- (void)eliminateScale
{
        [self clear];
        _totalScale = 1.0;
}

- (void)clear
{
        [_zoomingScroolView removeFromSuperview];
        _zoomingScroolView = nil;
        _zoomingImageView = nil;
        
}

- (void)addWaitingView
{
        [_waitingView startAnimating];
        
}
- (void)removeWaitingView
{
        [_waitingView stopAnimating];
        [_waitingView removeFromSuperview];
}

@end
