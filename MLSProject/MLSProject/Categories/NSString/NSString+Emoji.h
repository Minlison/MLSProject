//
//  NSString+Emoji.h
//  MinLison
//
//  Created by MinLison on 15/12/11.
//  Copyright © 2015年 MinLison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)

// 返回取消emoj表情的字符串
- (instancetype)stringByRemovingEmoji;

// 是否包含emoji
- (BOOL)isIncludingEmoji;

@end
