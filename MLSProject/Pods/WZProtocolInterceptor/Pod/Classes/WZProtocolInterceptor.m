#import  <objc/runtime.h>

#import "WZProtocolInterceptor.h"

static inline BOOL selector_belongsToProtocol(SEL selector, Protocol * protocol);

@implementation WZProtocolInterceptor
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.middleMan respondsToSelector:aSelector] &&
        [self isSelectorContainedInInterceptedProtocols:aSelector])
        return self.middleMan;

    if ([self.receiver respondsToSelector:aSelector])
        return self.receiver;

    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self.middleMan respondsToSelector:aSelector] &&
        [self isSelectorContainedInInterceptedProtocols:aSelector])
        return YES;

    if ([self.receiver respondsToSelector:aSelector])
        return YES;

    return [super respondsToSelector:aSelector];
}

- (instancetype)initWithInterceptedProtocol:(Protocol *)interceptedProtocol
{
    self = [super init];
    if (self) {
        _interceptedProtocols = @[interceptedProtocol];
    }
    return self;
}

- (instancetype)initWithInterceptedProtocols:(Protocol *)firstInterceptedProtocol, ...;
{
    self = [super init];
    if (self) {
        NSMutableArray * mutableProtocols = [NSMutableArray array];
        Protocol * eachInterceptedProtocol;
        va_list argumentList;
        if (firstInterceptedProtocol)
        {
            [mutableProtocols addObject:firstInterceptedProtocol];
            va_start(argumentList, firstInterceptedProtocol);
            while ((eachInterceptedProtocol = va_arg(argumentList, id))) {
                [mutableProtocols addObject:eachInterceptedProtocol];
            }
            va_end(argumentList);
        }
        _interceptedProtocols = [mutableProtocols copy];
    }
    return self;
}

- (instancetype)initWithArrayOfInterceptedProtocols:(NSArray *)arrayOfInterceptedProtocols
{
    self = [super init];
    if (self) {
        _interceptedProtocols = [arrayOfInterceptedProtocols copy];
    }
    return self;
}

- (void)dealloc
{
    _interceptedProtocols = nil;
}

- (BOOL)isSelectorContainedInInterceptedProtocols:(SEL)aSelector
{
    __block BOOL isSelectorContainedInInterceptedProtocols = NO;
    [self.interceptedProtocols enumerateObjectsUsingBlock:^(Protocol * protocol, NSUInteger idx, BOOL *stop) {
        isSelectorContainedInInterceptedProtocols = selector_belongsToProtocol(aSelector, protocol);
        * stop = isSelectorContainedInInterceptedProtocols;
    }];
    return isSelectorContainedInInterceptedProtocols;
}

@end

BOOL selector_belongsToProtocol(SEL selector, Protocol * protocol)
{
    // Reference: https://gist.github.com/numist/3838169
    for (int optionbits = 0; optionbits < (1 << 2); optionbits++) {
        BOOL required = optionbits & 1;
        BOOL instance = !(optionbits & (1 << 1));

        struct objc_method_description hasMethod = protocol_getMethodDescription(protocol, selector, required, instance);
        if (hasMethod.name || hasMethod.types) {
            return YES;
        }
    }

    return NO;
}
