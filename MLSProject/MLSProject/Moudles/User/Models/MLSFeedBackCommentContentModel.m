//
//  MLSFeedBackCommentContentModel.m
//  MinLison
//
//  Created by MinLison on 2017/11/20.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSFeedBackCommentContentModel.h"
#import "MLSFeedBackCommentContentCell.h"
@implementation MLSFeedBackCommentContentModel
- (Class)cellClass
{
        return [MLSFeedBackCommentContentCell class];
}

//===========================================================
// + (BOOL)automaticallyNotifiesObserversForKey:
//
//===========================================================
+ (BOOL)automaticallyNotifiesObserversForKey: (NSString *)theKey
{
        BOOL automatic;
        MLSFeedBackCommentContentModel *model = nil;
        if ([theKey isEqualToString:@keypath(model,offset)]) {
                automatic = NO;
        } else if ([theKey isEqualToString:@keypath(model,contentSize)]) {
                automatic = NO;
        } else {
                automatic = [super automaticallyNotifiesObserversForKey:theKey];
        }
        
        return automatic;
}

//===========================================================
// - setOffset:
//===========================================================
- (void)setOffset:(CGFloat)anOffset
{
        if (_offset != anOffset)
        {
                [self willChangeValueForKey:@keypath(self,offset)];
                _offset = anOffset;
                [self didChangeValueForKey:@keypath(self,offset)];
        }
}
//===========================================================
// - setContentSize:
//===========================================================
- (void)setContentSize:(CGSize)aContentSize
{
        if ( !CGSizeEqualToSize(_contentSize, aContentSize))
        {
                [self willChangeValueForKey:@keypath(self,contentSize)];
                _contentSize = aContentSize;
                [self didChangeValueForKey:@keypath(self,contentSize)];
        }
}
@end
