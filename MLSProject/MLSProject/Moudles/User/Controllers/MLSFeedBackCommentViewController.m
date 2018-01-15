//
//  MLSFeedBackCommentViewController.m
//  MinLison
//
//  Created by MinLison on 2017/11/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSFeedBackCommentViewController.h"
#import "MLSFeedBackCommentModel.h"
#import "MLSFeedBackContentRequest.h"
#import "MLSFeedBackCommentRequest.h"
#import "BaseCommentLoadingView.h"
#import "MLSFeedBackSendCommentRequest.h"
#import "MLSFeedBackCommentCell.h"
#import "MLSRefreshFooter.h"
#import "MLSBanCommentRequest.h"
@interface MLSFeedBackCommentViewController () <NIMutableTableViewModelDelegate>
@property(nonatomic, assign, readwrite) NSTimeInterval lastLoadingTimeInterval;
@property(nonatomic, strong) MLSFeedBackCommentRequest *request;
@property(nonatomic, assign) WGFeedBackCommentType commentType;
@property(nonatomic, copy) NSString *itemID;
@property(nonatomic, strong) MLSBanCommentRequest *banCommentRequest;
@end

@implementation MLSFeedBackCommentViewController
@synthesize loading = _loading;
- (void)initSubviews
{
        [super initSubviews];
        self.tableView.estimatedRowHeight = 125;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        [self configTableViewRefresh];
}
- (instancetype)initWithCommentType:(WGFeedBackCommentType)commentType itemID:(NSString *)itemID
{
        if (self = [super initWithStyle:(UITableViewStyleGrouped)]) {
                self.commentType = commentType;
                self.itemID = itemID;
        }
        return self;
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        [self loadData];
        if (self.commentType == WGCommentListTypeNormal)
        {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertSendModel:) name:WGFeedBackSendCommentSuccessNotifaction object:nil];
        }
}

- (void)insertSendModel:(NSNotification *)noti
{
        [self.tableViewModel insertObject:noti.object atRow:0 inSection:0];
        [self.tableView reloadData];
}
- (void)loadData
{
        [self configNimbus];
        [self setLoading:YES animation:YES];
        [self reloadData];
}
- (void)reloadData
{
        [self.request clearCache];
        [self.request paramInsert:self.itemID forKey:kRequestKeyItem_Id];
        [self.request paramInsert:@(self.commentType) forKey:kRequestKeyList_Type];
        [[self.request pullDown] startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof NSArray<MLSFeedBackCommentModel *> * _Nonnull data) {
                [self.tableViewModel addObjectsFromArray:data];
                [self.tableView reloadData];
                [self setSuccess];
                [self configTableViewRefresh];
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                [self setError:error];
        }];
}
- (void)configNimbus
{
        [super configNimbus];
        self.tableViewModel.delegate = self;
        [self.tableViewActions attachToClass:[MLSFeedBackCommentModel class] tapBlock:^BOOL(MLSFeedBackCommentModel * object, MLSFeedBackCommentViewController *target, NSIndexPath *indexPath) {
                
                if (LNUserManager.isLogin && LNUserManager.role.integerValue == WGUserRoleTypeAdmin)
                {
                        [target alertBanCommentController:object];
                }
                return YES;
        }];
}
- (void)alertBanCommentController:(MLSFeedBackCommentModel *)object
{
        [self.banCommentRequest paramInsert:NOT_NULL_STRING_DEFAULT_EMPTY(object.id) forKey:kRequestKeyID];
        QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"封禁用户" message:@"封禁用户删除评论" preferredStyle:(QMUIAlertControllerStyleAlert)];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"删除评论，不封禁用户" style:(QMUIAlertActionStyleDefault) handler:^(QMUIAlertAction *action) {
                [self.banCommentRequest paramInsert:@(WGBanCommentTypeWithOutBanUser) forKey:kRequestKeyType];
                [self sendBanCommentRequestAndDelObj:(MLSFeedBackCommentModel *)object];
        }]];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"删除评论，并且封禁用户" style:(QMUIAlertActionStyleDefault) handler:^(QMUIAlertAction *action) {
                [self.banCommentRequest paramInsert:@(WGBanCommentTypeWithBanUser) forKey:kRequestKeyType];
                [self sendBanCommentRequestAndDelObj:(MLSFeedBackCommentModel *)object];
        }]];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:(QMUIAlertActionStyleCancel) handler:nil]];
        
        [alert showWithAnimated:YES];
}
- (void)sendBanCommentRequestAndDelObj:(MLSFeedBackCommentModel *)object
{
        [self.banCommentRequest startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof NSString * _Nonnull data) {
                [MLSTipClass showText:request.serverRootModel.msg inView:self.view];
                NSIndexPath *indexPath = [self.tableViewModel indexPathForObject:object];
                if (indexPath)
                {
                        [self.tableViewModel removeObjectAtIndexPath:indexPath];
                        [self.tableView reloadSection:1 withRowAnimation:(UITableViewRowAnimationNone)];
                }
        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                [MLSTipClass showText:error.localizedDescription inView:self.view];
        }];
}
- (void)configTableViewRefresh
{
        @weakify(self);
        self.tableView.mj_footer = [MLSRefreshFooter footerWithRefreshingBlock:^{
                @strongify(self);
                [[self.request pullUp] startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof NSArray<MLSFeedBackCommentModel *> * _Nonnull data) {
                        if (data.count > 0)
                        {
                                [self.tableViewModel addObjectsFromArray:data];
                                [self.tableView reloadSection:0 withRowAnimation:(UITableViewRowAnimationNone)];
                                [self.tableView.mj_footer endRefreshing];
                        }
                } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                        // Do Nothing
                        if (error.code == APP_ERROR_CODE_CONTENT_NOT_EXIT_AUTH_FORBID)
                        {
                                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                        }
                        else
                        {
                                [self.tableView.mj_footer endRefreshing];
                        }
                }];
        }];
}
- (UITableViewCell *)tableViewModel: (NITableViewModel *)tableViewModel
                   cellForTableView: (UITableView *)tableView
                        atIndexPath: (NSIndexPath *)indexPath
                         withObject: (id)object
{
        UITableViewCell *cell = [self.cellFactory tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
        if ([cell isKindOfClass:[MLSFeedBackCommentCell class]])
        {
                MLSFeedBackCommentCell *commentCell = (MLSFeedBackCommentCell *)cell;
                @weakify(self);
                [commentCell setCommentCellActionBlock:^(WGFeedBackCommentActionType actionType, MLSFeedBackCommentModel * _Nonnull model, WGFeedBackCommentActionSuccessBlock  _Nonnull successBlock) {
                        @strongify(self);
                        [self sendCommentIsLike:actionType withModel:model successBlock:successBlock];
                }];
        }
        return cell;
}
- (void)sendCommentIsLike:(WGFeedBackCommentActionType)actionType withModel:(MLSFeedBackCommentModel *)model successBlock:(WGFeedBackCommentActionSuccessBlock)successBlock
{
        
}
- (void)configLocalIsLikeActionType:(WGFeedBackCommentActionType)actionType withModel:(MLSFeedBackCommentModel *)model successBlock:(WGFeedBackCommentActionSuccessBlock)successBlock
{
        if (actionType == WGFeedBackCommentActionTypeLike)
        {
                model.like = @(model.like.integerValue + 1).stringValue;
        }
        else if (actionType == WGFeedBackCommentActionTypeUnLike)
        {
                model.like = @(MAX(model.like.integerValue - 1, 0)).stringValue;
        }
        successBlock(YES);
}
/// MARK: - Super Method Overwrite
- (void)configEmptyView
{
        [super configEmptyView];
        self.emptyView.verticalOffset = -16;
        self.emptyView.loadingView = [[BaseCommentLoadingView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.emptyView.textLabelInsets = UIEdgeInsetsMake(-9, 0, 0, 0);
        [self.emptyView setImage:[UIImage pic_no_comment]];
        self.emptyView.textLabelTextColor = UIColorHex(0xe1e1e1);
        self.emptyView.textLabelFont = WGSystem13Font;
        [self.emptyView setTextLabelText:[NSString app_EmptyContent]];
        self.emptyView.contentView.backgroundColor = [UIColor whiteColor];
        self.emptyView.backgroundColor = [UIColor whiteColor];
}
- (void)setError:(NSError *)error completion:(void (^)(void))completion
{
        _loading = NO;
        self.lastLoadingTimeInterval = [[NSDate date] timeIntervalSince1970];
        NSString *errorDes = error.localizedDescription?:[NSString app_NeworkError];
        if (![error isAppError])
        {
                errorDes = [NSString app_RequestNormalError];
        }
        [self showEmptyViewWithLoading:NO image:[UIImage pic_no_content] text:errorDes detailText:nil buttonTitle:nil buttonAction:nil];
        if (completion)
        {
                completion();
        }
}
- (MLSFeedBackCommentRequest *)request
{
        if (!_request) {
                _request = [MLSFeedBackCommentRequest requestWithParams:nil];
        }
        return _request;
}
- (MLSBanCommentRequest *)banCommentRequest
{
        if (_banCommentRequest == nil) {
                _banCommentRequest = [MLSBanCommentRequest requestWithParams:nil];
        }
        return _banCommentRequest;
}
@end
