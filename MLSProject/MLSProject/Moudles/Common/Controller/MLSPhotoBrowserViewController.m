//
//  MLSPhotoBrowserViewController.m
//  MinLison
//
//  Created by MinLison on 2017/9/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSPhotoBrowserViewController.h"
#import "MLSPictureRequest.h"

typedef NS_ENUM(int, WGPhotoBrowserType)
{
        WGPhotoBrowserTypeSingle,
        WGPhotoBrowserTypeMutable,
};

@interface MLSPhotoBrowserViewController ()
@property(nonatomic, strong) NSString *picID;
@property(nonatomic, copy) NSString *imgUrl;
@property (nonatomic,strong) MLSPictureRequest *picRequest;
@property(nonatomic, strong) NSArray<MLSTipPicModel *> *picModels;
@property(nonatomic, assign) WGPhotoBrowserType browserType;

@end

@implementation MLSPhotoBrowserViewController

+ (instancetype)photoBrowserViewControllerWithPicID:(NSString *)picID
{
        MLSPhotoBrowserViewController *vc = [[MLSPhotoBrowserViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.picID = picID;
        vc.browserType = WGPhotoBrowserTypeMutable;
        return vc;
}
+ (instancetype)photoBrowserViewControllerWithImageUrl:(NSString *)imgUrl
{
        MLSPhotoBrowserViewController *vc = [[MLSPhotoBrowserViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.imgUrl = imgUrl;
        vc.browserType = WGPhotoBrowserTypeSingle;
        return vc;
}
- (void)viewDidLoad
{
        [super viewDidLoad];
        self.fd_prefersNavigationBarHidden = YES;
        [self loadData];
}

- (void)reloadData
{
        [self.picRequest clearCache];
        [self loadData];
}
- (void)loadData
{
        switch (self.browserType)
        {
                case WGPhotoBrowserTypeSingle:
                {
                        [self.imagePreviewView.collectionView reloadData];
                        [self.imagePreviewView setCurrentImageIndex:0 animated:YES];
                }
                        break;
                case WGPhotoBrowserTypeMutable:
                {
                        [self getPicDataWithpicID:NOT_NULL_STRING_DEFAULT_EMPTY(self.picID)];
                }
                        break;
                default:
                        break;
        }
}
//获取图集数据
- (void)getPicDataWithpicID:(NSString *)picID
{
        [MLSTipClass showLoadingInView:self.view];
        self.picRequest = [MLSPictureRequest requestWithParams:@{
                                                                kRequestKeyID:picID
                                                                }];
        [self.picRequest startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof NSArray<MLSTipPicModel *> * _Nonnull data) {
                self.picModels = data;
                [MLSTipClass hideLoadingInView:self.view];
                [self.imagePreviewView.collectionView reloadData];
                [self.imagePreviewView setCurrentImageIndex:0 animated:YES];
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                [MLSTipClass hideLoadingInView:self.view];
                [MLSTipClass showErrorWithText:error.localizedDescription inView:self.view];
        }];
}
- (NSString *)getImageUrlAtIndex:(NSUInteger)index
{
        switch (self.browserType)
        {
                case WGPhotoBrowserTypeSingle:
                {
                        return self.imgUrl;
                }
                        break;
                case WGPhotoBrowserTypeMutable:
                {
                        return [self.picModels objectAtIndex:index].img;
                }
                        break;
                default:
                        break;
        }
}
- (NSString *)getImageDescAtIndex:(NSUInteger)index
{
        switch (self.browserType)
        {
                case WGPhotoBrowserTypeSingle:
                {
                        return nil;
                }
                        break;
                case WGPhotoBrowserTypeMutable:
                {
                        return [self.picModels objectAtIndex:index].desc;
                }
                        break;
                default:
                        break;
        }
}
/// MARK: -  imagePreview 代理
- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView
{
        NSInteger count = self.browserType == WGPhotoBrowserTypeSingle ? 1 : self.picModels.count;
        self.pageControl.numberOfPages = count;
        self.pageControl.hidesForSinglePage = YES;
        self.contentLabel.hidden = (count == 1);
        self.pageControl.hidden = (count == 1);
        return count;
}
- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index
{
        [zoomImageView sd_internalSetImageWithURL:[NSURL URLWithString:[self getImageUrlAtIndex:index]] placeholderImage:nil options:(SDWebImageHighPriority) operationKey:nil setImageBlock:^(UIImage * _Nullable image, NSData * _Nullable imageData) {
                zoomImageView.image = image;
        } progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                zoomImageView.image = image;
                if (error)
                {
                        [zoomImageView showEmptyViewWithText:error.localizedDescription];
                }
        }];
}
// 返回要展示的媒体资源的类型（图片、live photo、视频），如果不实现此方法，则 QMUIImagePreviewView 将无法选择最合适的 cell 来复用从而略微增大系统开销
- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index
{
        return QMUIImagePreviewMediaTypeImage;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView willScrollHalfToIndex:(NSUInteger)index
{
        if (self.browserType == WGPhotoBrowserTypeMutable)
        {
                self.pageControl.currentPage = index;
                self.contentLabel.text = [self getImageDescAtIndex:index];
        }
}
- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location
{
        if (self.navigationController.viewControllers.count > 1)
        {
                [self backButtonDidClick:nil];
        }
        else
        {
                [self endPreviewFading];
        }
}
- (void)startPreviewFromRectInScreen:(CGRect)rect
{
        [super startPreviewFromRectInScreen:rect];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
        return UIStatusBarStyleLightContent;
}


@end
