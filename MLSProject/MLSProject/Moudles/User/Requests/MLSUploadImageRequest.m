//
//  MLSUploadImageRequest.m
//  MinLison
//
//  Created by MinLison on 2017/11/5.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUploadImageRequest.h"
#import "RMUUid.h"
#import "MLSSecurityTools.h"
@interface MLSUploadImageRequest ()
@property(nonatomic, copy) NSURL *imgFileUrl;
@end
@implementation MLSUploadImageRequest
- (instancetype)initWithImgFileUrl:(NSURL *)imgFileUrl
{
        MLSUploadImageRequest *request = [[MLSUploadImageRequest alloc] initWithParams:@{
                                                                                       kRequestKeyName : imgFileUrl.absoluteString.lastPathComponent.stringByDeletingPathExtension
                                                                                       }];
        request.imgFileUrl = imgFileUrl;
        
        NSAssert(imgFileUrl, @"imgFilePath 不能为空");
        request.constructingBodyBlock = ^(id<AFMultipartFormData>  _Nonnull formData) {
                NSError *error = nil;
                [formData appendPartWithFileURL:imgFileUrl name:@"file" error:&error];
                if (error) {
                        NSLogError(@"upload image appendPartWithFileURL error %@",error);
                }
        };
        return request;
}
- (Class)contentType
{
        return [MLSUploadImgModel class];
}

- (BOOL)needSign
{
        return NO;
}
- (BOOL)blockSelfUntilDone
{
        return YES;
}
- (NSString *)url
{
        return @"/api.php/file/api";
}

- (BOOL)needCache
{
        return NO;
}
@end
