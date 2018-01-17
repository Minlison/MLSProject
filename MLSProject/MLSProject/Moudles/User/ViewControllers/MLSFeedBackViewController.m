//
//  MLSFeedBackViewController.m
//  MinLison
//
//  Created by MinLison on 2017/11/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSFeedBackViewController.h"
#import "MLSFeedBackCommentViewController.h"
#import "MLSPageViewController.h"
#import "MLSFeedBackContentRequest.h"
#import "MLSFeedBackSendCommentRequest.h"
#import "MLSFeedBackCommentContentModel.h"
@interface MLSFeedBackViewController () <WGPageViewControllerDelegate, QMUITableViewDelegate>
@property(nonatomic, strong) MLSPageViewController *pageViewController;
@property(nonatomic, strong) MLSFeedBackContentRequest *contentRequest;
@property(nonatomic, strong) MLSFeedBackContentModel *contentModel;
@property(nonatomic, strong) MLSFeedBackSendCommentRequest *sendCommentRequest;
@property(nonatomic, strong) MLSFeedBackCommentContentModel *commentContentModel;
@property(nonatomic, assign) BOOL refreshCache;
@end

@implementation MLSFeedBackViewController

- (void)didInitializedWithStyle:(UITableViewStyle)style
{
        self.commentContentModel = [[MLSFeedBackCommentContentModel alloc] init];
        self.pageViewController = [[MLSPageViewController alloc] init];
        self.pageViewController.segmentTitles = @[[NSString app_Overhead],[NSString app_Newest]];
        self.pageViewController.customTopSortView = YES;
        
        [self.pageViewController willMoveToParentViewController:self];
        [self addChildViewController:self.pageViewController];
        self.commentContentModel.commentContentView = self.pageViewController.view;
        [self.pageViewController didMoveToParentViewController:self];
        self.pageViewController.pageDelegate = self;
        self.pageViewController.segmentLayoutEdgeInsets = UIEdgeInsetsMake(0, __WGWidth(14), 0, 0); // 跟底部 cell 的头像距离左边一直
        
        [super didInitializedWithStyle:style];
}
- (void)viewDidLoad
{
        [super viewDidLoad];
        [self setLoading:YES animation:YES];
        [self configNimbus];
//        [self.KVOController observe:self.tableView keyPath:@keypath(self.tableView,contentOffset) options:(NSKeyValueObservingOptionNew) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
//                CGPoint tableOffset = self.tableView.contentOffset;
//                if (CGPointEqualToPoint(CGPointZero, tableOffset) || CGSizeEqualToSize(self.tableView.contentSize, CGSizeZero)) {
//                        return ;
//                }
//                if (tableOffset.y + self.tableView.height > self.tableView.contentSize.height || tableOffset.y < 0)
//                {
//                        [self.tableView setContentOffset:CGPointZero];
//                        [self.tableView resignFirstResponder];
//                        [self.pageViewController.currentViewController becomeFirstResponder];
//                        return;
//                }
//        }];
}
- (void)viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
        if (self.isFirstAppear)
        {
                [self loadData];
        }
}

- (void)reloadData
{
        self.contentRequest.ignoreCache = YES;
        [self loadData];
}
- (void)loadData
{
        [self setLoading:YES animation:YES];
        [self.tableViewModel removeAll];
        [self.contentRequest startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof MLSFeedBackContentModel * _Nonnull data) {
                self.contentModel = data;
                [self.pageViewController reloadData];
                [self.pageViewController.segmentControl setSelectedSegmentIndex:0];
                
                [self.tableViewModel addSectionWithTitle:nil];
                [self.tableViewModel addObject:data];
                [self.tableViewModel addSectionWithTitle:nil];
                [self.tableViewModel addObject:self.commentContentModel];
                
                [self.tableView reloadData];
                [self setSuccess];
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                [self setError:error];
        }];
}
- (void)configNimbus
{
        [super configNimbus];
        [self.tableViewModel addSectionWithTitle:nil];
        [self.tableViewActions forwardingTo:self];
        [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:[UITableViewHeaderFooterView className]];
}
/// MARK: - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        if (section == 1)
        {
                return __WGHeight(40);
        }
        return 0.0001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[UITableViewHeaderFooterView className]];
        [header removeAllSubviews];
        if (section == 1)
        {
                [header addSubview:self.pageViewController.topSortView];
                [self.pageViewController.topSortView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(header);
                }];
                return header;
        }
        return header;
}
/// MARK: - PageController Delegate
- (NSInteger)countOfContentItems
{
        return self.contentModel ? 2 : 0;
}

- (UIViewController *)contentControllerAtIndex:(NSInteger)index
{
        WGFeedBackCommentType commentType = WGFeedBackCommentTypeTop;
        if (index == 1) {
                commentType = WGFeedBackCommentTypeNew;
        }
        MLSFeedBackCommentViewController *commentVC = [[MLSFeedBackCommentViewController alloc] initWithCommentType:commentType itemID:self.contentModel.id];
        return commentVC;
}

- (void)configController:(MLSFeedBackCommentViewController *)controller atIndex:(NSInteger)index
{
        
}
- (void)controllerDidShow:(MLSFeedBackCommentViewController *)controller atIndex:(NSInteger)index
{
        @weakify(self);
        [self.KVOController observe:controller.tableView keyPath:@keypath(controller.tableView,contentOffset) options:(NSKeyValueObservingOptionNew) block:^(MLSFeedBackViewController *  _Nullable observer, BaseTableView *  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                @strongify(self);
                
                CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
                if ( CGPointEqualToPoint(offset, CGPointZero) )
                {
                        return;
                }
                /// 上移
                CGRect section1Rect = [self.tableView rectForHeaderInSection:1];
                if (offset.y > 0 && self.tableView.contentOffset.y < section1Rect.origin.y - 1)
                {
                        [self.tableView scrollToRow:0 inSection:1 atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
                        [object setContentOffset:CGPointZero animated:NO];
                        return;
                }
                else if (offset.y < 0 )
                {
                        [self.tableView scrollToRow:0 inSection:0 atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
                        [object setContentOffset:CGPointZero animated:NO];
                        return;
                }
        }];
}

- (BOOL)hasTopSegment
{
        return YES;
}

- (WGSegmentScrollDirection)scrollDirection
{
        return WGSegmentScrollDirectionHorizontal;
}

/// MARK: - Comment
- (BOOL)alwaysShowCommentView
{
        return YES;
}
- (BOOL)commentForceLayoutBringToTop
{
        return YES;
}
- (BaseCommentToolBarType)commentToolBarType
{
        return BaseCommentToolBarTypeNormal;
}
- (void)commentViewSendButtonDidClick:(id<BaseCommentToolBarProtocol>)commentView hideBlock:(void (^)(BOOL))hideBlock cleanTextBlock:(void (^)(BOOL))cleanTextBlock
{
        if (NULLString(commentView.text))
        {
                [super commentViewSendButtonDidClick:commentView hideBlock:hideBlock cleanTextBlock:cleanTextBlock];
                return;
        }
        [self.sendCommentRequest paramInsert:self.contentModel.id forKey:kRequestKeyItem_Id];
        [self.sendCommentRequest paramInsert:@(WGCommentListTypeNormal) forKey:kRequestKeyList_Type];
        [self.sendCommentRequest paramInsert:@(0) forKey:kRequestKeyPid];
        [self.sendCommentRequest paramInsert:commentView.text forKey:kRequestKeyContent];
        
        [self.sendCommentRequest startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof MLSFeedBackCommentModel * _Nonnull data) {
                [MLSTipClass showSuccessWithText:request.serverRootModel.msg inView:self.view];
                hideBlock(YES);
                cleanTextBlock(YES);
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                [MLSTipClass showText:error.localizedDescription inView:self.view];
                hideBlock(YES);
                cleanTextBlock(NO);
        }];
}

/// MARK: -Lazy
- (MLSFeedBackContentRequest *)contentRequest
{
        if (_contentRequest == nil) {
                _contentRequest = [MLSFeedBackContentRequest requestWithParams:nil];
        }
        return _contentRequest;
}
- (MLSFeedBackSendCommentRequest *)sendCommentRequest
{
        if (!_sendCommentRequest) {
                _sendCommentRequest = [MLSFeedBackSendCommentRequest requestWithParams:nil];
        }
        return _sendCommentRequest;
}
@end
