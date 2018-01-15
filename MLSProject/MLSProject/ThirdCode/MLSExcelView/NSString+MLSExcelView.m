//
//  NSString+MLSExcelView.m
//  10000ui-swift
//
//  Created by MinLison on 09/10/2017.
//  Copyright © 2017 yizmh. All rights reserved.
//

#import "NSString+MLSExcelView.h"

@implementation NSString (MLSExcelViewView)

- (CGSize)MLS_sizeWithFont:(UIFont *)font constraint:(CGSize)constraint {
    
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    NSDictionary *attributes = @{ NSFontAttributeName: font };
    CGRect bounds = [self boundingRectWithSize:constraint options:options attributes:attributes context:nil];
    CGSize size = bounds.size;
    return size;
}

@end
