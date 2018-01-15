//
//  BaseControllerViewProtocol.h
//  MinLison
//
//  Created by MinLison on 2017/9/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef BaseControllerViewProtocol_h
#define BaseControllerViewProtocol_h
#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@protocol BaseControllerViewProtocol <NSObject>

/**
 初始化 view
 */
- (void)setupView;


@end

NS_ASSUME_NONNULL_END
#endif /* BaseControllerViewProtocol_h */
