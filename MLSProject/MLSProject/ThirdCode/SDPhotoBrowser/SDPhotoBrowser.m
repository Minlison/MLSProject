//
//  SDPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "SDPhotoBrowser.h"
//#import "UIImageView+WebCache.h"
#import "SDBrowserImageView.h"
#import "MLSSheetView.h"

//  ============在这里方便配置样式相关设置===========

//                      ||
//                      ||
//                      ||
//                     \\//
//                      \/

#import "SDPhotoBrowserConfig.h"

//  =============================================

@implementation SDPhotoBrowser
{
        UIScrollView *_scrollView;
        BOOL _hasShowedFistView;
        UILabel *_indexLabel;
        UIActivityIndicatorView *_indicatorView;
        BOOL _willDisappear;
        UIPageControl *_pageControl;
        UIImageView *_backImageView;
}

- (id)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = SDPhotoBrowserBackgrounColor;
                
        }
        return self;
}


- (void)didMoveToSuperview
{
        [self setupScrollView];
        
        [self setupToolbars];
}

- (void)dealloc
{
        [[UIApplication sharedApplication].keyWindow removeObserver:self forKeyPath:@"frame"];
}

- (void)setupToolbars
{
        UIImageView *backimagView = [[UIImageView alloc]init];
        backimagView.image = [UIImage imageNamed:@"image_shadow"];
        // 1. 序标
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.textAlignment = NSTextAlignmentLeft;
        indexLabel.textColor = [UIColor whiteColor];
        indexLabel.font = [UIFont boldSystemFontOfSize:16];
        [indexLabel setQmui_lineHeight:20];
        indexLabel.numberOfLines = 0;
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        pageControl.bounds = CGRectMake(0, 0, __MAIN_SCREEN_WIDTH__, 15);
        indexLabel.clipsToBounds = YES;
        if (self.models.count >= 1)
        {
                pageControl.numberOfPages = self.imageCount;
                pageControl.hidden = !(self.imageCount-1);
                MLSTipPicModel *model = self.models.firstObject;
                indexLabel.text = model.desc;
        }
        [self addSubview:backimagView];
        [self addSubview:indexLabel];
        [self addSubview:pageControl];
        _backImageView = backimagView;
        _indexLabel = indexLabel;
        _pageControl = pageControl;
        
}

- (void)saveImage
{
        int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
        UIImageView *currentImageView = _scrollView.subviews[index];
        UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicator.center = self.center;
        _indicatorView = indicator;
        [[UIApplication sharedApplication].keyWindow addSubview:indicator];
        [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
        [_indicatorView removeFromSuperview];
        UIImageView *tipView = [[UIImageView alloc]init];
        tipView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        tipView.layer.cornerRadius = 3;
        tipView.clipsToBounds = YES;
        tipView.bounds = CGRectMake(0, 0, __WGWidth(120.0f), __WGWidth(96.0f));
        tipView.center = self.center;
        UIImageView *imgView = [[UIImageView alloc]init];
        [tipView addSubview:imgView];
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont boldSystemFontOfSize:14];
        [tipView addSubview:tipLabel];
        [[UIApplication sharedApplication].keyWindow addSubview:tipView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:tipView];
        if (error)
        {
                tipLabel.hidden = YES;
                imgView.hidden = NO;
                tipLabel.center = tipView.center;
                tipLabel.text = SDPhotoBrowserSaveImageFailText;
        }   else {
                imgView.frame = CGRectMake(__WGWidth(49), __WGWidth(27), __WGWidth(26), __WGWidth(20));
                tipLabel.frame = CGRectMake(0, __WGWidth(66), __WGWidth(120), __WGWidth(20));
                tipLabel.hidden = NO;
                imgView.hidden = NO;
                imgView.image = [UIImage imageNamed:@"image_icon_finish"];
                tipLabel.text = SDPhotoBrowserSaveImageSuccessText;
                [tipView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
        }
}

- (void)setupScrollView
{
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        for (int i = 0; i < self.imageCount; i++) {
                
                SDBrowserImageView *imageView = [[SDBrowserImageView alloc] init];
                
                imageView.tag = i;
                
                // 单击图片
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
                
                // 双击放大图片
                UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
                doubleTap.numberOfTapsRequired = 2;
                //长摁
                
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
                
                [singleTap requireGestureRecognizerToFail:doubleTap];
                
                [imageView addGestureRecognizer:singleTap];
                [imageView addGestureRecognizer:doubleTap];
                [imageView addGestureRecognizer:longPress];
                
                [_scrollView addSubview:imageView];
        }
        
        [self setupImageOfImageViewForIndex:self.currentImageIndex];
        
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
        SDBrowserImageView *imageView = _scrollView.subviews[index];
        self.currentImageIndex = index;
        if (imageView.hasLoadedImage) return;
        if ([self highQualityImageURLForIndex:index]) {
                [imageView setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
        } else {
                imageView.image = [self placeholderImageForIndex:index];
        }
        imageView.hasLoadedImage = YES;
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
        _scrollView.hidden = YES;
        _willDisappear = YES;
        
        SDBrowserImageView *currentImageView = (SDBrowserImageView *)recognizer.view;
        
        UIView *sourceView = nil;
        
        sourceView = self.sourceImagesContainerView;
        
        //    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
        
        UIImageView *tempView = [[UIImageView alloc] init];
        tempView.contentMode = sourceView.contentMode;
        tempView.clipsToBounds = YES;
        tempView.image = currentImageView.image;
        CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
        
        if (!currentImageView.image) { // 防止 因imageview的image加载失败 导致 崩溃
                h = self.bounds.size.height;
        }
        
        tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
        tempView.center = self.center;
        
        [self addSubview:tempView];
        
        [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
                //        tempView.frame = targetTemp;
                tempView.alpha = 0;
                self.backgroundColor = [UIColor clearColor];
                _indexLabel.alpha = 0;
                _pageControl.alpha = 0;
                _backImageView.alpha = 0;
                
        } completion:^(BOOL finished) {
                
                if (self.delegate) {
                        
                        [self.delegate closeSuperViewController];
                }
                
                [self removeFromSuperview];
        }];
}

- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer
{
        SDBrowserImageView *imageView = (SDBrowserImageView *)recognizer.view;
        CGFloat scale;
        if (imageView.isScaled) {
                scale = 1.0;
        } else {
                scale = 2.0;
        }
        
        SDBrowserImageView *view = (SDBrowserImageView *)recognizer.view;
        
        [view doubleTapToZommWithScale:scale];
}

-(void)longPress:(UILongPressGestureRecognizer *)longPress{
        
        if ([longPress state] == UIGestureRecognizerStateBegan) {
                
                MLSSheetView *sheetView = [[MLSSheetView alloc]init];
                
                sheetView.alpha = 0;
                
                [self addSubview:sheetView];
                
                [UIView animateWithDuration:0.25 animations:^{
                        
                        sheetView.alpha = 1;
                }];
                
                [sheetView setClickBlock:^(CZSheetViewClickType type){
                        
                        if (type == CZSheetViewClickTypeSave){
                                
                                [self saveImage];
                                
                        }else if(type == CZSheetViewClickTypeCancle){
                                
                                //                [self photoClick:nil];
                                
                        }
                        
                }];
                
        }
}

- (void)layoutSubviews
{
        [super layoutSubviews];
        
        CGRect rect = self.bounds;
        rect.size.width += SDPhotoBrowserImageViewMargin * 2;
        
        _scrollView.bounds = rect;
        _scrollView.center = self.center;
        
        CGFloat y = 0;
        CGFloat w = _scrollView.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
        CGFloat h = _scrollView.frame.size.height;
        
        
        
        [_scrollView.subviews enumerateObjectsUsingBlock:^(SDBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
                CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
                obj.frame = CGRectMake(x, y, w, h);
        }];
        
        _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
        _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
        
        
        if (!_hasShowedFistView) {
                [self showFirstImage];
        }
        
        
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.trailing.bottom.equalTo(self);
                
                make.height.mas_equalTo(__MAIN_SCREEN_HEIGHT__*2/5);
        }];
  
        [_indexLabel mas_remakeConstraints:^(MASConstraintMaker *make) {

                make.bottom.equalTo(self.mas_bottom).offset(-__MAIN_SCREEN_HEIGHT__*0.05);

                make.trailing.equalTo(self).offset(-20);

                make.leading.equalTo(self).offset(20);
                
                make.height.mas_equalTo(120);

        }];
        
        _pageControl.center = CGPointMake(self.bounds.size.width * 0.5,__MAIN_SCREEN_HEIGHT__-__WGWidth(20.0f));
        
}

- (void)show
{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.frame = window.bounds;
        self.alpha = 0;
        [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
        [window.rootViewController.view addSubview:self];
        
        [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
                self.alpha = 1;
        } completion:^(BOOL finished) {
                
        }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context
{
        if ([keyPath isEqualToString:@"frame"]) {
                self.frame = object.bounds;
                SDBrowserImageView *currentImageView = _scrollView.subviews[_currentImageIndex];
                if ([currentImageView isKindOfClass:[SDBrowserImageView class]]) {
                        [currentImageView clear];
                }
        }
}

- (void)showFirstImage
{
        UIView *sourceView = nil;
        
        if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
                UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
                NSIndexPath *path = [NSIndexPath indexPathForItem:self.currentImageIndex inSection:0];
                sourceView = [view cellForItemAtIndexPath:path];
        }else {
                sourceView = self.sourceImagesContainerView;
        }
        CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
        
        UIImageView *tempView = [[UIImageView alloc] init];
        tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
        
        [self addSubview:tempView];
        
        CGRect targetTemp = [_scrollView.subviews[self.currentImageIndex] bounds];
        
        tempView.frame = rect;
        tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
        _scrollView.hidden = YES;
        
        
        [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
                tempView.center = self.center;
                tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
        } completion:^(BOOL finished) {
                _hasShowedFistView = YES;
                [tempView removeFromSuperview];
                _scrollView.hidden = NO;
        }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
        if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
                return [self.delegate photoBrowser:self placeholderImageForIndex:index];
        }
        return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
        if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
                return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
        }
        return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
        
        // 有过缩放的图片在拖动一定距离后清除缩放
        CGFloat margin = 150;
        CGFloat x = scrollView.contentOffset.x;
        if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
                SDBrowserImageView *imageView = _scrollView.subviews[index];
                if (imageView.isScaled) {
                        [UIView animateWithDuration:0.5 animations:^{
                                imageView.transform = CGAffineTransformIdentity;
                        } completion:^(BOOL finished) {
                                [imageView eliminateScale];
                        }];
                }
        }
        
        [self setupImageOfImageViewForIndex:index];
        
        if (!_willDisappear)
        {
                MLSTipPicModel *model = self.models[index];
                _indexLabel.text = model.desc;
                _pageControl.currentPage = index;
                
                if (self.delegate)
                {
                        [self.delegate photoBrowser:self currentIndex:index];
                }
        }
}

-(void)setModels:(NSArray<MLSTipPicModel *> *)models{

        _models = models;
}


@end
