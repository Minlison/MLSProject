//
//  BaseTableViewDelegate.h
//  MinLison
//
//  Created by MinLison on 2017/11/7.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface BaseTableViewDelegate : NSObject <QMUITableViewDelegate>
/**
 创建代理
 
 @param receiver 接收代理通知的对象
 @return  dataSource
 */
- (instancetype)initWithReceiver:(nullable id<QMUITableViewDelegate>)receiver NS_DESIGNATED_INITIALIZER;

/**
 代理接收代理消息
 */
@property(nonatomic, weak) id <QMUITableViewDelegate> receiver;

@end
NS_ASSUME_NONNULL_END
