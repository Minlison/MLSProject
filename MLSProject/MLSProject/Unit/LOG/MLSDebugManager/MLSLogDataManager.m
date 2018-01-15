//
//  MLSLogDataManager.m
//  MLSLogger
//
//  Created by MinLison on 16/8/18.
//  Copyright © 2016年 MinLison. All rights reserved.
//

#import "MLSLogDataManager.h"
#import "MLSDebugInstance.h"

static int CMD = 0;
#define CMD_CLEAR 0x01

dispatch_queue_t data_manage_queue()
{
        static dispatch_queue_t data_queue;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                data_queue = dispatch_queue_create("com.mlsdebugview", DISPATCH_QUEUE_SERIAL);
        });
        return data_queue;
}

@interface MLSLogDataManager() <NSStreamDelegate>
@property (strong, nonatomic) NSMutableArray <NSString *>*dataArray;
@property (copy, nonatomic) void (^OutPutObserver)(NSString *str);
@property (assign, nonatomic) NSInteger maxCount;
@property (assign, nonatomic) CGFloat maxMemory;

@end

@implementation MLSLogDataManager
+ (instancetype)shareManager
{
        static MLSLogDataManager *manager;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                manager = [[self alloc] init];
        });
        return manager;
}
- (instancetype)init
{
        if (self = [super init])
        {
                _maxMemory = 0;
                _maxCount = 0;
        }
        return self;
}

- (void)addLogStr:(NSString *)format
{
        dispatch_async(data_manage_queue(), ^{
                @autoreleasepool
                {
                        if (CMD & CMD_CLEAR)
                        {
                                [self.dataArray removeAllObjects];
                                CMD &= (~CMD_CLEAR);
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        if (self.OutPutObserver)
                                        {
                                                self.OutPutObserver(nil);
                                        }
                                });
                        }
                        else
                        {
                                // get the timestamp
                                NSDate *now = [NSDate date];
                                static dispatch_once_t onceToken;
                                static NSDateFormatter *formatter;
                                dispatch_once(&onceToken, ^{
                                        formatter = [NSDateFormatter new];
                                        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                                });
                                NSString *dateString = [formatter stringFromDate:now];
                                
                                dateString = [dateString stringByAppendingString:format];
                                
                                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.dataArray];
                                
                                
                                [self.dataArray insertObject:dateString atIndex:0];
                                
                                // 内存是否占满
                                while (data.length >= self.maxMemory && self.dataArray.count > 0)
                                {
                                        [self.dataArray removeLastObject];
                                }
                                
                                // 数量是否超标
                                if (self.dataArray.count > self.maxCount)
                                {
                                        for (int i = 0; i < self.dataArray.count - self.maxCount; i++)
                                        {
                                                [self.dataArray removeLastObject];
                                        }
                                }
                                
                                NSString *outPutStr = [self.dataArray componentsJoinedByString:@"\n\n\n************************MLSDebug************************\n\n\n"];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        if (self.OutPutObserver)
                                        {
                                                self.OutPutObserver(outPutStr.mutableCopy);
                                        }
                                });
                        }
                }
        });
        
}
- (void)addOutPutStringObserver:(void (^)(NSString *outPut))observer
{
        self.OutPutObserver = observer;
        dispatch_async(data_manage_queue(), ^{
                NSString *outPutStr = [self.dataArray componentsJoinedByString:@"\n\n\n************************MLSDebug************************\n\n\n"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (self.OutPutObserver)
                        {
                                self.OutPutObserver(outPutStr.mutableCopy);
                        }
                });
        });
}
- (void)clear
{
        @synchronized (self)
        {
                CMD |= CMD_CLEAR;
        }
        [self addLogStr:@""];
}
- (NSMutableArray *)dataArray
{
        if (_dataArray == nil) {
                _dataArray = [[NSMutableArray alloc] initWithCapacity:self.maxCount];
        }
        return _dataArray;
}
- (NSInteger)maxCount
{
        if (_maxCount == 0)
        {
                _maxCount = [MLSDebugInstance shareInstance].maxLogCount - 2;
        }
        return _maxCount;
}
- (CGFloat)maxMemory
{
        if (_maxMemory <= 1024)
        {
                _maxMemory = [MLSDebugInstance shareInstance].maxMemory * 1000;
        }
        return _maxMemory;
}
@end
