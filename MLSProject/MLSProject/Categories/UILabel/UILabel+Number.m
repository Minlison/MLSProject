//
//  UILabel+Number.m
//  MinLison
//
//  Created by qcm on 17/3/3.
//  Copyright © 2017年 MinLison. All rights reserved.
//

#import "UILabel+Number.h"

@implementation UILabel (Number)
- (CGFloat)numberOfText
{
        // 获取单行时候的内容的size
        CGSize singleSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
        // 获取多行时候,文字的size
        CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
        // 返回计算的行数
        return ceil( textSize.height / singleSize.height);
}
- (BOOL)needExpend
{
	CGSize orginsize = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
	NSInteger numberOfLines = self.numberOfLines;
	self.numberOfLines = 0;
	CGSize textSize = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
	self.numberOfLines = numberOfLines;
	[self sizeToFit];
	return (textSize.height > orginsize.height);
}
- (BOOL)needExpendWithLineNumbers:(int)number
{
        NSInteger numberOfLines = self.numberOfLines;
        self.numberOfLines = number;
        CGSize orginsize = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
        
        self.numberOfLines = 0;
        CGSize textSize = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
        
        self.numberOfLines = numberOfLines;
        [self sizeToFit];
        return (textSize.height > orginsize.height);
}
@end
