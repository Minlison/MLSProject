//
//  BaseViewProtocol.h
//  MLSProject
//
//  Created by MinLison on 2017/9/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef BaseViewProtocol_h
#define BaseViewProtocol_h


@protocol BaseViewProtocol <NSObject>

/**
 初始化 view
 */
@concrete
- (void)setupView;

@end

#endif /* BaseViewProtocol_h */
