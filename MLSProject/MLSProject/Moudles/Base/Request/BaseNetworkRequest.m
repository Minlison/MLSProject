//
//  BaseNetworkRequest.m
//  MinLison
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "Cache.h"
#import <YTKNetwork/YTKNetworkPrivate.h>

@interface BaseCacheMetadata : NSObject<NSSecureCoding>

@property (nonatomic, assign) long long version;
@property (nonatomic, assign) NSStringEncoding stringEncoding;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSString *appVersionString;
@property(nonatomic, strong) NSData *data;
@end

@implementation BaseCacheMetadata

+ (BOOL)supportsSecureCoding {
        return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
        [aCoder encodeObject:@(self.version) forKey:NSStringFromSelector(@selector(version))];
        [aCoder encodeObject:@(self.stringEncoding) forKey:NSStringFromSelector(@selector(stringEncoding))];
        [aCoder encodeObject:self.creationDate forKey:NSStringFromSelector(@selector(creationDate))];
        [aCoder encodeObject:self.appVersionString forKey:NSStringFromSelector(@selector(appVersionString))];
        [aCoder encodeObject:self.data forKey:NSStringFromSelector(@selector(data))];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
        self = [self init];
        if (!self) {
                return nil;
        }
        
        self.version = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(version))] integerValue];
        self.stringEncoding = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(stringEncoding))] integerValue];
        self.creationDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(creationDate))];
        self.appVersionString = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(appVersionString))];
        self.data = [aDecoder decodeObjectOfClass:[NSData class] forKey:NSStringFromSelector(@selector(data))];
        return self;
}

@end

static NSUInteger networkTag = 0;
@interface BaseNetworkRequest ()
@property (nonatomic, strong) NSData *cacheData;
@property (nonatomic, strong) NSString *cacheString;
@property (nonatomic, strong) id cacheJSON;
@property (nonatomic, strong) NSXMLParser *cacheXML;
@property (nonatomic, assign) BOOL dataFromCache;

@property (nonatomic, strong) BaseCacheMetadata *cacheMetadata;
@end

@implementation BaseNetworkRequest
- (instancetype)init
{
        self = [super init];
        if (self) {
                self.tag = networkTag++;
        }
        return self;
}

- (void)start {
        if (self.ignoreCache) {
                [self startWithoutCache];
                return;
        }
        
        // Do not cache download request.
        if (self.resumableDownloadPath) {
                [self startWithoutCache];
                return;
        }
        
        if (![self loadCacheWithError:nil]) {
                [self startWithoutCache];
                return;
        }
        
        _dataFromCache = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
                [self requestCompletePreprocessor];
                [self requestCompleteFilter];
                BaseNetworkRequest *strongSelf = self;
                [strongSelf.delegate requestFinished:strongSelf];
                if (strongSelf.successCompletionBlock) {
                        strongSelf.successCompletionBlock(strongSelf);
                }
                [strongSelf clearCompletionBlock];
        });
}

- (void)startWithoutCache {
        [self clearCacheVariables];
        [super start];
}

#pragma mark - Network Request Delegate

- (void)requestCompletePreprocessor {
        [super requestCompletePreprocessor];
        [self saveResponseDataToCacheFile:[super responseData]];
}
#pragma mark - Subclass Override

- (NSInteger)cacheTimeInSeconds {
        return -1;
}

- (long long)cacheVersion {
        return 0;
}
/// MARK: - 拦截 cache， 自己管理缓存
- (BOOL)isDataFromCache {
        return _dataFromCache;
}

- (NSData *)responseData {
        if (_cacheData) {
                return _cacheData;
        }
        return [super responseData];
}

- (NSString *)responseString {
        if (_cacheString) {
                return _cacheString;
        }
        return [super responseString];
}

- (id)responseJSONObject {
        if (_cacheJSON) {
                return _cacheJSON;
        }
        return [super responseJSONObject];
}

- (id)responseObject {
        if (_cacheJSON) {
                return _cacheJSON;
        }
        if (_cacheXML) {
                return _cacheXML;
        }
        if (_cacheData) {
                return _cacheData;
        }
        return [super responseObject];
}

- (BOOL)loadCacheWithError:(NSError * _Nullable __autoreleasing *)error {
        // Make sure cache time in valid.
        if ([self cacheTimeInSeconds] < 0) {
                if (error) {
                        *error = [NSError errorWithDomain:YTKRequestCacheErrorDomain code:YTKRequestCacheErrorInvalidCacheTime userInfo:@{ NSLocalizedDescriptionKey:@"Invalid cache time"}];
                }
                return NO;
        }
        
        // Try load cache.
        if (![self loadCacheMetadata]) {
                if (error) {
                        *error = [NSError errorWithDomain:YTKRequestCacheErrorDomain code:YTKRequestCacheErrorInvalidCacheData userInfo:@{ NSLocalizedDescriptionKey:@"Invalid cache data"}];
                }
                return NO;
        }
        
        // Check if cache is still valid.
        if (![self validateCacheWithError:error]) {
                return NO;
        }
        
        // Try load cache.
        if (![self loadCacheData]) {
                if (error) {
                        *error = [NSError errorWithDomain:YTKRequestCacheErrorDomain code:YTKRequestCacheErrorInvalidCacheData userInfo:@{ NSLocalizedDescriptionKey:@"Invalid cache data"}];
                }
                return NO;
        }
        
        return YES;
}
- (BOOL)validateCacheWithError:(NSError * _Nullable __autoreleasing *)error {
        
        // Version
        long long cacheVersionFileContent = self.cacheMetadata.version;
        if (cacheVersionFileContent != [self cacheVersion]) {
                if (error) {
                        *error = [NSError errorWithDomain:YTKRequestCacheErrorDomain code:YTKRequestCacheErrorVersionMismatch userInfo:@{ NSLocalizedDescriptionKey:@"Cache version mismatch"}];
                }
                return NO;
        }
        
        // App version
        NSString *appVersionString = self.cacheMetadata.appVersionString;
        NSString *currentAppVersionString = [YTKNetworkUtils appVersionString];
        if (appVersionString || currentAppVersionString) {
                if (appVersionString.length != currentAppVersionString.length || ![appVersionString isEqualToString:currentAppVersionString]) {
                        if (error) {
                                *error = [NSError errorWithDomain:YTKRequestCacheErrorDomain code:YTKRequestCacheErrorAppVersionMismatch userInfo:@{ NSLocalizedDescriptionKey:@"App version mismatch"}];
                        }
                        return NO;
                }
        }
        return YES;
}
- (BOOL)loadCacheMetadata
{
        NSString *cacheFileName = [self cacheFileName];
        if ( [ShareDefaultCache containsObjectForKey:cacheFileName] )
        {
                self.cacheMetadata = (BaseCacheMetadata *)[ShareDefaultCache objectForKey:cacheFileName];
                return self.cacheMetadata.data != nil;
        }
        return NO;
}
- (BOOL)loadCacheData {
        
        NSError *error = nil;
        NSData *data = self.cacheMetadata.data;
        
        if (data != nil)
        {
                _cacheData = data;
                _cacheString = [[NSString alloc] initWithData:_cacheData encoding:self.cacheMetadata.stringEncoding];
                switch (self.responseSerializerType) {
                        case YTKResponseSerializerTypeHTTP:
                                // Do nothing.
                                return YES;
                        case YTKResponseSerializerTypeJSON:
                                _cacheJSON = [NSJSONSerialization JSONObjectWithData:_cacheData options:(NSJSONReadingOptions)0 error:&error];
                                return error == nil;
                        case YTKResponseSerializerTypeXMLParser:
                                _cacheXML = [[NSXMLParser alloc] initWithData:_cacheData];
                                return YES;
                }
        }
        return NO;
}
- (void)saveResponseDataToCacheFile:(NSData *)data
{
        if (data == nil)
        {
                [ShareDefaultCache removeObjectForKey:[self cacheFileName]];
                return;
        }
        if ([self cacheTimeInSeconds] > 0 && ![self isDataFromCache])
        {
                BaseCacheMetadata *metadata = [[BaseCacheMetadata alloc] init];
                metadata.version = [self cacheVersion];
                metadata.stringEncoding = [YTKNetworkUtils stringEncodingWithRequest:self];
                metadata.creationDate = [NSDate date];
                metadata.appVersionString = [YTKNetworkUtils appVersionString];
                metadata.data = data;
                [ShareDefaultCache setObject:metadata forKey:[self cacheFileName]];
        }
}
- (void)clearCache
{
        [ShareDefaultCache removeObjectForKey:[self cacheFileName]];
}
- (void)clearCacheVariables {
        _cacheData = nil;
        _cacheXML = nil;
        _cacheJSON = nil;
        _cacheString = nil;
        _dataFromCache = NO;
}
- (NSString *)cacheIdentifier
{
        return nil;
}
- (NSString *)cacheFileName {
        NSString *cacheIdentifier = [self cacheIdentifier];
        if (cacheIdentifier)
        {
                return cacheIdentifier.md5String.md5String;
        }
        NSString *requestUrl = [self requestUrl];
        NSString *baseUrl = [YTKNetworkConfig sharedConfig].baseUrl;
        id argument = [self cacheFileNameFilterForRequestArgument:[self requestArgument]];
        NSString *requestInfo = [NSString stringWithFormat:@"Method:%ld Host:%@ Url:%@ Argument:%@",
                                 (long)[self requestMethod], baseUrl, requestUrl, argument];
        NSString *cacheFileName = [YTKNetworkUtils md5StringFromString:requestInfo];
        return cacheFileName;
}

@end
