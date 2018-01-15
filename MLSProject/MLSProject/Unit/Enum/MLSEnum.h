
//
//  MLSEnum.h
//  MinLison
//
//  Created by minlison on 2017/9/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef MLSEnum_h
#define MLSEnum_h

/**
 tabbar的位置

 - LNTabbarIndexHome: 首页
 - LNTabbarIndexYard: 场地预定
 - LNTabbarIndexEvent: 赛事活动
 - LNTabbarIndexMine: 我的
 */
typedef NS_ENUM(NSInteger,LNTabbarIndex)
{
        LNTabbarIndexHome = 0,
        LNTabbarIndexYard = 1,
        LNTabbarIndexEvent = 2,
        LNTabbarIndexMine = 3,
};

/**
 内容类型, 针对全局的所有内容的类型说明
 // 1热门产品 2促销信息 3新闻动态 4体育项目的赛事活动 5体育项目的新闻 6体育项目的活动介绍
 - LNArticleContentTypeHot: 热门产品
 - LNArticleContentTypePromotion: 促销信息
 - LNArticleContentTypeNews: 新闻动态
 - LNArticleContentTypeSportActivity: 体育项目的赛事活动
 - LNArticleContentTypeSportNews: 体育项目的新闻
 - LNArticleContentTypeSportIntroduce: 体育项目的活动介绍
 */
typedef NS_ENUM(NSInteger,LNArticleContentType)
{
        LNArticleContentTypeHot = 1,
        LNArticleContentTypePromotion = 2,
        LNArticleContentTypeNews = 3,
        LNArticleContentTypeSportActivity = 4,
        LNArticleContentTypeSportNews = 5,
        LNArticleContentTypeSportIntroduce = 6,
};
/**
 订单类型
 
 - LNOrderStatusTypeWaitingPay: 等待付款
 - LNOrderStatusTypePayed: 已付款但为确认
 - LNOrderStatusTypeCanceled: 已取消
 - LNOrderStatusTypeCompleted: 已完成
 */
typedef NS_ENUM(NSInteger,LNOrderStatusType)
{
        LNOrderStatusTypeWaitingPay,
        LNOrderStatusTypePayed,
        LNOrderStatusTypeCanceled,
        LNOrderStatusTypeCompleted,
        LNOrderStatusTypeAll,
        LNOrderStatusTypeMax,
};
static inline NSString *LNOrderStatusDesForType(LNOrderStatusType type)
{
        NSString *des = nil;
        switch (type) {
                case LNOrderStatusTypeWaitingPay:
                {
                        des = @"待支付";
                }
                        break;
                case LNOrderStatusTypePayed:
                {
                        des = @"已支付";
                }
                        break;
                case LNOrderStatusTypeCanceled:
                {
                        des = @"已取消";
                }
                        break;
                case LNOrderStatusTypeCompleted:
                {
                        des = @"已完成";
                }
                        break;
                        
                default:
                        des = nil;
                        break;
        }
        return des;
};


typedef NS_ENUM(NSInteger, LNPersonalTrainerOrderStatus)
{
        LNPersonalTrainerOrderStatusWaitingReview,
        LNPersonalTrainerOrderStatusReviewing,
        LNPersonalTrainerOrderStatusReviewPass,
        LNPersonalTrainerOrderStatusReviewNotPass,
        LNPersonalTrainerOrderStatusMax,
};
static inline NSString *LNPersonalTrainerOrderDesForType(LNPersonalTrainerOrderStatus type)
{
        NSString *des = nil;
        switch (type) {
                case LNPersonalTrainerOrderStatusWaitingReview:
                {
                        des = @"等待审核";
                }
                        break;
                case LNPersonalTrainerOrderStatusReviewing:
                {
                        des = @"审核中";
                }
                        break;
                case LNPersonalTrainerOrderStatusReviewPass:
                {
                        des = @"审核通过";
                }
                        break;
                case LNPersonalTrainerOrderStatusReviewNotPass:
                {
                        des = @"审核未通过";
                }
                        break;
                
                        
                default:
                        des = nil;
                        break;
        }
        return des;
};


/**
 会员类型
 后台对应 service_id
 - LNVipServiceKindTypeCreateCardAndCharge: 办卡充值
 - LNVipServiceKindTypeSiteBooking: 场地预订
 - LNVipServiceKindTypeBuyTickets: 购买门票
 - LNVipServiceKindTypeSportsClass: 体育培训
 - LNVipServiceKindTypeMatchSignUp: 赛事报名
 - LNVipServiceKindTypeSportShop: 运动商城
 - LNVipServiceKindTypeParkingCar: 停车缴费
 */
typedef NS_ENUM(NSInteger, LNVipServiceKindType)
{
        LNVipServiceKindTypeCreateCardAndCharge = 1,
        LNVipServiceKindTypeSiteBooking = 2,
        LNVipServiceKindTypeBuyTickets = 3,
        LNVipServiceKindTypeSportsClass = 4,
        LNVipServiceKindTypeMatchSignUp = 5,
        LNVipServiceKindTypeSportShop = 6,
        LNVipServiceKindTypeParkingCar = 7,
        LNVipServiceKindTypeMax,
};

/**
 购物车类型
 根据后台定义
 - LNShopCartTypeShopping: 运动商城商品
 - LNShopCartTypeBuyTickets: 购买门票
 */
typedef NS_ENUM(NSInteger, LNShopCartType)
{
        LNShopCartTypeShopping = 1,
        LNShopCartTypeBuyTickets = 2
};


/**
 门票类型

 - LNBuyTicketsTypeSwimChildTicket: 儿童游泳馆
 - LNBuyTicketsTypeParentChildTicket: 亲子运动员门票
 */
typedef NS_ENUM(NSInteger, LNBuyTicketsType)
{
        LNBuyTicketsTypeSwimChildTicket = 1,
        LNBuyTicketsTypeParentChildTicket = 2
};


/**
 专题中内容类型
 1~99的部分ID是预留给“内容类型”的，以保持一致
 
 - WGTopicContentTypeArticle: 文章
 - WGTopicContentTypePic: 图片
 - WGTopicContentTypeVideo: 视频
 - WGTopicContentTypeMusci: 音乐
 - WGTopicContentTypeBrief: 简讯
 - WGTopicContentTypeUrl: 网页
 - WGTopicContentTypeAD: 广告
 - WGTopicContentTypeSubTopic: 子专题列表入口, 此类型用于实现专题的嵌套，即专题里的专题列表（树形结构的专题列表），一个专题里可能返回此列表里的一个或多个内容类型。
 */
typedef NS_ENUM(NSInteger, WGTopicContentType)
{
        WGTopicContentTypeArticle = 1,
        WGTopicContentTypePic   = 2,
        WGTopicContentTypeVideo = 3,
        WGTopicContentTypeMusci = 4,
        WGTopicContentTypeBrief = 5,
    
        WGTopicContentTypeUrl   = 100,
        WGTopicContentTypeAD    = 101,
        WGTopicContentTypeSubTopic = 102,
};
/**
 评论的内容类型
 
 - WGCommentTypeArticle: 文章
 - WGCommentTypeePic: 图片
 - WGCommentTypeVideo: 视频
 - WGCommentTypeMusci: 音乐
 - WGCommentTypeBrief: 简讯
 - WGCommentTypeFeedBack:反馈
 */
typedef NS_ENUM(NSInteger, WGCommentContentType)
{
        WGCommentContentTypeArticle = 1,
        WGCommentContentTypeePic   = 2,
        WGCommentContentTypeVideo = 3,
        WGCommentContentTypeMusci = 4,
        WGCommentContentTypeBrief = 5,
        WGCommentContentTypeFeedBack = 6,
       
};
/**
 专题的显示类型
 
 - WGTopicShowTypeRound: 轮播图
 - WGTopicShowTypeTopic: 专题
 */
typedef NS_ENUM(NSInteger, WGTopicShowType)
{
        WGTopicShowTypeRound = 1,
        WGTopicShowTypeTopic = 2,
};

/**
 专题的页面类型（可能会在同一页面的多个位置显示不同的专题列表）
 - WGTopicPageAll: 所有页面(默认值)
 */
typedef NS_ENUM(NSInteger, WGTopicPageType)
{
        WGTopicPageAll = 1,
};

/**
 首页简讯底部toolBar按钮类型

 - WGToolBarViewTypeLike: 喜欢
 - WGToolBarViewTypeComment: 评论
 - WGToolBarViewTypeShare: 分享
 */
typedef NS_ENUM(NSInteger,WGToolBarViewType)
{
        WGToolBarViewTypeUnLike = 0,
        WGToolBarViewTypeLike,
        WGToolBarViewTypeComment,
        WGToolBarViewTypeShare,
};

/**
 跳转浏览器类型

 - WGBrowserTypeBuiltIn: 内置浏览器
 - WGBrowserTypeOther: 外部浏览器
 */
typedef NS_ENUM(NSInteger, WGBrowserType)
{
        WGBrowserTypeBuiltIn = 1,
        WGBrowserTypeOther = 2,
};

/**
 视频清晰度

 - WGVideoDefinitionUnKnown: 未知
 - WGVideoDefinition720p: 720p
 - WGVideoDefinition1080p: 1080p
 - WGVideoDefinition2k: 2k
 - WGVideoDefinition4k: 4k
 */
typedef NS_ENUM(NSInteger, WGVideoDefinition)
{
        WGVideoDefinitionUnKnown = 0,
        WGVideoDefinition720p = 1,
        WGVideoDefinition1080p = 2,
        WGVideoDefinition2k = 3,
        WGVideoDefinition4k = 4,
};

/**
 cell点击状态类型
 
 - WGCellTouchTypeBegan: 开始触摸
 - WGCellTouchTypeEnd: 结束触摸
 */
typedef NS_ENUM(NSInteger, WGCellTouchType)
{
        WGCellTouchTypeBegan = 1,
        WGCellTouchTypeEnd = 2,
};

/**
 用户权限角色

 - WGUserRoleTypeNormal: 普通用户
 - WGUserRoleTypeAdmin: 管理员
 */
typedef NS_ENUM(NSInteger, WGUserRoleType)
{
        WGUserRoleTypeNormal = 0,
        WGUserRoleTypeAdmin = 1,
};

/**
 三方登录类型
 - LNLoginTypePhone: 手机
 - LNLoginTypeQQ:  QQ
 - LNLoginTypeWebchat: 微信
 - LNLoginTypeWeibo: 微博
 */
typedef NS_ENUM(NSInteger, LNLoginType)
{
        LNLoginTypePhone = -1,
        LNLoginTypeUnKnown = 0,
        /// 服务器定义 begin
        LNLoginTypeQQ = 3,
        LNLoginTypeWebchat = 4,
        LNLoginTypeWeibo = 5,
        /// 服务器定义 end
};

/**
 分享网站类型

 - WGThirdShareWebTypeWebTimeLine: 朋友圈
 - WGThirdShareWebTypeWebchat: 微信
 - WGThirdShareWebTypeQQ:  QQ
 - WGThirdShareWebTypeQQZone: QQ 空间
 - WGThirdShareWebTypeWeibo: 微博
 */
typedef NS_ENUM(NSInteger, WGThirdShareWebType)
{
        WGThirdShareWebTypeWebTimeLine = 1,
        WGThirdShareWebTypeWebchat = 2,
        WGThirdShareWebTypeQQ = 3,
        WGThirdShareWebTypeQQZone = 4,
        WGThirdShareWebTypeWeibo = 5,
};

/**
 图片上传类型

 - WGImageUploadTypeUnKnown: 未知
 - WGImageUploadTypeUserHead: 头像
 */
typedef NS_ENUM(NSInteger, WGImageUploadType)
{
        WGImageUploadTypeUnKnown,
        WGImageUploadTypeUserHead,
};

/**
 评论列表类型

 - WGCommentListTypeNormal: 0：普通评论列表（按时间倒序排列）
 - WGCommentListTypeWonderful: 1：精彩评论列表（按点赞数倒序排列，页数默认为1，没分页）
 - WGCommentListTypeStickTop: 2：置顶评论列表（按后台设置排列）
 */
typedef NS_ENUM(NSInteger, WGCommentListType)
{
        WGCommentListTypeNormal,
        WGCommentListTypeWonderful,
        WGCommentListTypeStickTop,
};

/**
  删除评论的类型

 - WGBanCommentTypeWithOutBanUser: 删除评论，不封禁用户
 - WGBanCommentTypeWithBanUser: 删除评论，并且封禁用户
 */
typedef NS_ENUM(NSInteger, WGBanCommentType)
{
        WGBanCommentTypeWithOutBanUser,
        WGBanCommentTypeWithBanUser,
};

/////// MARK: - Request Type

/**
 文章列表请求类型

 - LNArticleListRequestTypeHome: 首页
 - LNArticleListRequestTypeSport: 运动馆
 */
typedef NS_ENUM(NSInteger,LNArticleListRequestType)
{
        LNArticleListRequestTypeHome,
        LNArticleListRequestTypeSport,
};

/**
 轮播图请求类型

 - LNBannerRequestTypeHome: 首页
 - LNBannerRequestTypeSport: 运动馆
 */
typedef NS_ENUM(NSInteger,LNBannerRequestType)
{
        LNBannerRequestTypeHome,
        LNBannerRequestTypeSport,
};
#endif /* MLSEnum_h */
