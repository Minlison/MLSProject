//
//  MLSPictureRequest.m
//  MinLison
//
//  Created by minlison on 2017/9/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSPictureRequest.h"

@implementation MLSPictureRequest
- (BOOL)contentIsArray
{
        return YES;
}

- (Class)contentType
{
        return [MLSTipPicModel class];
}
@end
