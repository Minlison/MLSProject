#import <Foundation/Foundation.h>

@interface WZProtocolInterceptor : NSObject
@property (nonatomic, readonly, copy) NSArray * interceptedProtocols;
@property (nonatomic, weak) id receiver;
@property (nonatomic, weak) id middleMan;

- (instancetype)initWithInterceptedProtocol:(Protocol *)interceptedProtocol;
- (instancetype)initWithInterceptedProtocols:(Protocol *)firstInterceptedProtocol, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype)initWithArrayOfInterceptedProtocols:(NSArray *)arrayOfInterceptedProtocols;
@end
