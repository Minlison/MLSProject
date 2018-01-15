//
//  MLSCommentViewController.m
//  MinLison
//
//  Created by minlison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSCommentViewController.h"
#import "MLSCommentListRequest.h"
#import "MLSSendCommentRequest.h"
#import "BaseCommentLoadingView.h"
#import "MLSPopLoginViewController.h"
#import "MLSEmptyCommentModel.h"
#import "MLSCommentTableViewCell.h"
#import "MLSRefreshFooter.h"
#import "MLSBanCommentRequest.h"
@interface MLSCommentViewController ()
@property (nonatomic,strong)  MLSCommentListRequest *normalCommentListRequest;
@property (nonatomic,strong)  MLSCommentListRequest *wonderfulCommentListRequest;
@property(nonatomic, copy) NSString *itemID;
@property(nonatomic, assign) LNArticleContentType contentType;
@property(nonatomic, strong)  MLSSendCommentRequest *sendCommentRequest;
@property(nonatomic, copy) WGSendCommentCallBackBlock sendCommentCallBack;
@property(nonatomic, strong) MLSBanCommentRequest *banCommentRequest;
@property(nonatomic, strong) NSMutableDictionary <NSNumber *,NSNumber*>*commentCountDict;
@end

@implementation MLSCommentViewController

+ (instancetype)commentViewControllerWithItemID:(NSString *)itemID contentType:(LNArticleContentType)contentType
{
        MLSCommentViewController *vc = [[MLSCommentViewController alloc] init];
        vc.itemID = itemID;
        vc.contentType = contentType;
        return vc;
}
- (void)viewDidLoad
{
        [super viewDidLoad];
        [self loadData];
}
- (void)initSubviews
{
        [super initSubviews];
        [self configNimbus];
        [self.tableViewActions forwardingTo:self.controllerView];
        self.privateDelegate.receiver = self.controllerView;
        [self.commentCountDict enumerateKeysAndObjectsUsingBlock:^(NSNumber *  _Nonnull key, NSNumber *  _Nonnull obj, BOOL * _Nonnull stop) {
                [self.controllerView setCommentCount:obj.integerValue type:key.integerValue];
        }];
        /// 新增两个组
        [self.tableViewModel addSectionWithTitle:nil];
        [self.tableViewModel addSectionWithTitle:nil];
        
        [self.tableViewActions attachToClass:[MLSCommentModel class] tapBlock:^BOOL(MLSCommentModel * object, MLSCommentViewController *target, NSIndexPath *indexPath) {
                
                if (LNUserManager.isLogin && LNUserManager.role.integerValue == WGUserRoleTypeAdmin)
                {
                        [target alertBanCommentController:object];
                }
                return YES;
        }];
}
- (void)alertBanCommentController:(MLSCommentModel *)object
{
        [self.banCommentRequest paramInsert:NOT_NULL_STRING_DEFAULT_EMPTY(object.id) forKey:kRequestKeyID];
        QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"封禁用户" message:@"封禁用户删除评论" preferredStyle:(QMUIAlertControllerStyleAlert)];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"删除评论，不封禁用户" style:(QMUIAlertActionStyleDefault) handler:^(QMUIAlertAction *action) {
                [self.banCommentRequest paramInsert:@(WGBanCommentTypeWithOutBanUser) forKey:kRequestKeyType];
                [self sendBanCommentRequestAndDelObj:(MLSCommentModel *)object];
        }]];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"删除评论，并且封禁用户" style:(QMUIAlertActionStyleDefault) handler:^(QMUIAlertAction *action) {
                [self.banCommentRequest paramInsert:@(WGBanCommentTypeWithBanUser) forKey:kRequestKeyType];
                [self sendBanCommentRequestAndDelObj:(MLSCommentModel *)object];
        }]];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:(QMUIAlertActionStyleCancel) handler:nil]];
        
        [alert showWithAnimated:YES];
}
- (void)sendBanCommentRequestAndDelObj:(MLSCommentModel *)object
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
- (void)setCommentCount:(NSUInteger)count type:(WGCommentListType)type
{
        [self.commentCountDict setObject:@(count) forKey:@(type)];
}
- (void)setSendCommentCallBackBlock:(WGSendCommentCallBackBlock)callBack
{
        self.sendCommentCallBack = callBack;
}
- (void)didInitialized
{
        [super didInitialized];
        self.commentCountDict = [NSMutableDictionary dictionaryWithCapacity:2];
}
- (void)loadData
{
        [self setLoading:YES animation:YES];
        [self reloadData];
}
- (void)reloadData
{
        @weakify(self);
        // 精彩评论
        NSDictionary *commentParam = @{
                                       kRequestKeyItem_Id : self.itemID,
                                       kRequestKeyList_Type : @(WGCommentListTypeWonderful)
                                       };
        self.wonderfulCommentListRequest = [MLSCommentListRequest requestWithParams:commentParam];
        self.wonderfulCommentListRequest.groupIgnoreError = YES;
        [self.wonderfulCommentListRequest setSuccessCallBack:^(__kindof BaseRequest * _Nonnull request, __kindof NSArray<MLSCommentModel *> * _Nonnull data) {
                @strongify(self);
                /// 清除第一组数据
                [self.tableViewModel removeObjectsInSection:0];
                if (data.count > 0)
                {
                        [self.tableViewModel addObjectsFromArray:data toSection:0];
                }
                else
                {
                        [self.tableViewModel addObject:[MLSEmptyCommentModel emptyModel] toSection:0];
                }
        }];
        [self.wonderfulCommentListRequest setFailedCallBack:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                @strongify(self);
                [self.tableViewModel removeObjectsInSection:0];
                [self.tableViewModel addObject:[MLSEmptyCommentModel emptyModel] toSection:0];
        }];
        
        // 普通评论
        NSDictionary *param = @{
                                kRequestKeyType:@(self.contentType),
                                kRequestKeyItem_Id:self.itemID,
                                kRequestKeyList_Type: @(WGCommentListTypeNormal)
                                };
        self.normalCommentListRequest = [MLSCommentListRequest requestWithParams:param];
        
        [[self.normalCommentListRequest pullDown] setSuccessCallBack:^(__kindof BaseRequest * _Nonnull request, __kindof NSArray<MLSCommentModel *> * _Nonnull data) {
                @strongify(self);
                /// 清除第二组数据
                [self.tableViewModel removeObjectsInSection:1];
                [self.tableViewModel addObjectsFromArray:data toSection:1];
        }];
        [@[self.normalCommentListRequest,self.wonderfulCommentListRequest] startSync:NO requestWithSuccess:^(NSArray *requests) {
                @strongify(self);
                [self.tableView reloadData];
                [self setSuccess];
                [self configTableViewRefresh];
        } failed:^(NSArray *requests, NSError *error) {
                @strongify(self);
                [self setError:error];
        }];
}
- (void)configTableViewRefresh
{
        @weakify(self);
        self.tableView.mj_footer = [MLSRefreshFooter footerWithRefreshingBlock:^{
                @strongify(self);
                [[self.normalCommentListRequest pullUp] startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof NSArray<MLSCommentModel *> * _Nonnull data) {
                        if (data.count > 0) {
                                [self.tableViewModel addObjectsFromArray:data toSection:1];
                                [self.tableView reloadSection:1 withRowAnimation:(UITableViewRowAnimationNone)];
                                [self.tableView.mj_footer endRefreshing];
                        } else {
                                [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
/// MARK: - NITableviewModelDelegate
- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
        UITableViewCell *cell = [super tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
        if ([cell isKindOfClass:[MLSCommentTableViewCell class]])
        {
                [self configCommentCommentCell:(MLSCommentTableViewCell *)cell];
        }
        return cell;
}
- (void)configCommentCommentCell:(MLSCommentTableViewCell *)commentCell
{
        @weakify(self);
        [commentCell setCommentCellActionBlock:^(WGCommentActionType actionType, MLSCommentModel *model, WGCommentActionSuccessBlock successBlock) {
                @strongify(self);
                [self clickLikeisLike:actionType withModel:model completed:successBlock];
        }];
}
// MARK: - 喜欢点击事件处理
- (void)clickLikeisLike:(WGCommentActionType)actionType withModel:(MLSCommentModel *)model completed:(WGCommentActionSuccessBlock)completed
{
}

- (void)configLocalIsLikeActionType:(WGCommentActionType)actionType withModel:(MLSCommentModel *)model successBlock:(WGCommentActionSuccessBlock)successBlock
{
        if (actionType == WGToolBarViewTypeLike)
        {
                model.like = @(model.like.integerValue + 1).stringValue;
        }

        else if (actionType == WGToolBarViewTypeUnLike)
        {
                model.like = @(MAX(model.like.integerValue - 1, 0)).stringValue;
        }
        successBlock(YES);
}


/// MARK: - Super Method Overwrite
- (void)configEmptyView
{
        [super configEmptyView];
        self.emptyView.textLabelInsets = UIEdgeInsetsMake(-9, 0, 0, 0);
        self.emptyView.loadingView = [[BaseCommentLoadingView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.emptyView setImage:[UIImage pic_no_comment]];
        self.emptyView.textLabelTextColor = UIColorHex(0xe1e1e1);
        self.emptyView.textLabelFont= WGSystem13Font;
        [self.emptyView setTextLabelText:[NSString app_EmptyComment]];
        self.emptyView.contentView.backgroundColor = [UIColor whiteColor];
        self.emptyView.backgroundColor = [UIColor whiteColor];
}
- (void)setError:(NSError *)error completion:(void (^)(void))completion
{
        NSString *errorDes = error.localizedDescription?:[NSString app_NeworkError];
        if (![error isAppError] && error.code != 31)
        {
                errorDes = [NSString app_RequestNormalError];
        }else{
                errorDes = [NSString app_EmptyComment];
        }
        [self showEmptyViewWithLoading:NO image:[UIImage pic_no_comment] text:errorDes detailText:nil buttonTitle:nil buttonAction:nil];
        if (completion)
        {
                completion();
        }
}

//评论框相关
- (BOOL)alwaysShowCommentView
{
        return YES;
}
- (BaseCommentToolBarType)commentToolBarType
{
        return BaseCommentToolBarTypeNormal;
}
- (void)commentViewSendButtonDidClick:(id<BaseCommentToolBarProtocol>)commentView hideBlock:(void (^)(BOOL))hideBlock cleanTextBlock:(void (^)(BOOL))cleanTextBlock
{
        @weakify(self);
        [LNUserManager popLoginIfNeedInViewController:self completion:^{
                @strongify(self);
                if (LNUserManager.isLogin)
                {
                        if (NULLString(commentView.text))
                        {
                                [super commentViewSendButtonDidClick:commentView hideBlock:hideBlock cleanTextBlock:cleanTextBlock];
                                return;
                        }
                        [self.sendCommentRequest paramInsert:self.itemID forKey:kRequestKeyItem_Id];
                        [self.sendCommentRequest paramInsert:@(WGCommentListTypeNormal) forKey:kRequestKeyList_Type];
                        [self.sendCommentRequest paramInsert:@(0) forKey:kRequestKeyPid];
                        [self.sendCommentRequest paramInsert:commentView.text forKey:kRequestKeyContent];
                        [self.sendCommentRequest startWithSuccess:^(__kindof BaseRequest * _Nonnull request, __kindof MLSCommentModel * _Nonnull data) {
                                if (self.sendCommentCallBack && data) {
                                        self.sendCommentCallBack(@[data]);
                                }
                                [self.controllerView addCommentCount:1 type:(WGCommentListTypeNormal)];
                                [self.tableViewModel insertObject:data atRow:0 inSection:1];
                                [self.tableView reloadData];
//                                [self.tableView reloadRow:0 inSection:1 withRowAnimation:(UITableViewRowAnimationNone)];
                                if (self.emptyViewShowing)
                                {
                                        [self setSuccess];
                                }
                                [MLSTipClass showSuccessWithText:request.serverRootModel.msg inView:self.view];
                                hideBlock(YES);
                                cleanTextBlock(YES);
                        } failed:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                                [MLSTipClass showText:error.localizedDescription inView:self.view];
                                hideBlock(YES);
                                cleanTextBlock(NO);
                        }];
                }
        } dismiss:^{
                
        }];
}
- (BOOL)commentForceLayoutBringToTop
{
        return YES;
}
- (MLSSendCommentRequest *)sendCommentRequest
{
        if (!_sendCommentRequest) {
                _sendCommentRequest = [MLSSendCommentRequest requestWithParams:nil];
        }
        return _sendCommentRequest;
}
- (MLSBanCommentRequest *)banCommentRequest
{
        if (_banCommentRequest == nil) {
                _banCommentRequest = [MLSBanCommentRequest requestWithParams:nil];
        }
        return _banCommentRequest;
}
@end

