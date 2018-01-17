//
//  MLSSendCommentRequest.h
//  MinLison
//
//  Created by minlison on 2017/10/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseRequest.h"
#import "MLSCommentModel.h"

FOUNDATION_EXTERN NSString *WGWGSendCommentSuccessNotifaction;

@interface MLSSendCommentRequest : BaseRequest<MLSCommentModel *>

@end
