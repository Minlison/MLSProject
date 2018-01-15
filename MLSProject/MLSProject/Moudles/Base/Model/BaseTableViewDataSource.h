//
//  BaseTableViewDataSource.h
//  MinLison
//
//  Created by MinLison on 2017/11/7.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface BaseTableViewDataSource : NSObject <QMUITableViewDataSource>

/**
 创建数据源

 @param receiver 接收数据源通知的对象
 @return  dataSource
 */
- (instancetype)initWithReceiver:(nullable id<QMUITableViewDataSource>)receiver NS_DESIGNATED_INITIALIZER;

/**
 代理接收代理消息
 */
@property(nonatomic, weak) id <QMUITableViewDataSource> receiver;
@end
NS_ASSUME_NONNULL_END
