//
//  MLSFeedBackCommentModel.m
//  MinLison
//
//  Created by MinLison on 2017/11/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSFeedBackCommentModel.h"
#import "MLSFeedBackCommentCell.h"
#import "MLSFeedBackReplayCommentCell.h"
@implementation MLSFeedBackCommentModel
- (Class)cellClass
{
        if (!NULLString(self.reply_user_id))
        {
                return [MLSFeedBackReplayCommentCell class];
        }
        return [MLSFeedBackCommentCell class];
}
@end
