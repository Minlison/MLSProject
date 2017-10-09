//
//  MLSPlayerViewModel.h
//  MLSProject
//
//  Created by MinLison on 2017/9/12.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
 NS_ASSUME_NONNULL_BEGIN
@interface MLSPlayerViewModel <ObjcType> : NSObject

/**
 所有列表
 
 @return 列表
 */
- (NSArray <ObjcType>*)list;

/**
 总大小

 @return 个数
 */
- (NSUInteger)size;

/**
 从最后一个添加
 
 @param obj 对象
 */
- (void)add:(ObjcType)obj;

/**
 插入对象
 
 @param obj 对象
 @param index 索引
 */
- (void)insert:(ObjcType)obj atIndex:(NSUInteger)index;

/**
 获取对应索引位置对象

 @param index 索引
 @return 对象 如果索引不正确 ,返回 nil
 */
- (nullable ObjcType)objAtIndex:(NSUInteger)index;

/**
 获取对象索引 (必须之前插入过该对象)

 @param obj 对象
 @return 索引
 */
- (NSUInteger)indexForObj:(ObjcType)obj;

/**
 选中对象

 @param obj 对象
 */
- (void)selectedObj:(ObjcType)obj;

/**
 选中索引

 @param index 索引
 */
- (void)selectedIndex:(NSUInteger)index;

/**
 替换对象

 @param obj 新对象
 @param index 替换对象的位置
 */
- (BOOL)replaceWithObj:(ObjcType)obj atIndex:(NSUInteger)index;

/**
 第一个
 */
- (ObjcType)first;

/**
 最后一个
 */
- (ObjcType)last;

/**
 从当前开始的上一个
 */
- (ObjcType)pre;

/**
 是否有下一个
 */
- (BOOL)haveNext;
/**
 从当前开始的下一个
 */
- (ObjcType)next;

/**
 当前正在使用的对象

 @return 当前对象
 */
- (ObjcType)current;

@end
NS_ASSUME_NONNULL_END
