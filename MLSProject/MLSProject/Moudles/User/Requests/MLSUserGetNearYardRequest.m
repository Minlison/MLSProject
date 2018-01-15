//
//  MLSUserGetNearYardRequest.m
//  MLSProject
//
//  Created by MinLison on 2017/12/1.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUserGetNearYardRequest.h"

@implementation MLSUserGetNearYardRequest
- (Class)contentType
{
        return [MLSYardModel class];
}
- (NSString *)url
{
        return @"/api.php/area/getarea";
}
- (BOOL)blockSelfUntilDone
{
        return YES;
}
@end
