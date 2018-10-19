//
//  XZSingleList.h
//  XZSingleList
//
//  Created by kkxz on 2018/10/18.
//  Copyright © 2018年 kkxz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZListNode.h"
NS_ASSUME_NONNULL_BEGIN

@interface XZSingleList : NSObject
//包含节点个数
@property(assign,nonatomic,readonly)NSInteger count;

/**
 添加节点
 @param node 可以是节点本身，也可以是节点的值
 @return 被添加的节点
 */
-(XZListNode*)addNode:(id)node;

/**
 移除节点
 @param node 被移除的节点
 */
- (void)removeNode:(XZListNode*)node;

/**
 通过索引-移除节点
 @param index 指定的索引 【0 ~ count-1】
 @return 被移除的节点 [nil 表示操作失败]
 */
- (nullable XZListNode*)removeNodeAtIndex:(NSInteger)index;

/**
 将节点添加到指定索引
 @param node 可以是节点本身，也可以是节点的值
 @param index 指定的位置 【0 ~ count】
 @return 被添加的节点 [nil 表示操作失败]
 */
- (nullable XZListNode*)insertNode:(id)node atIndex:(NSInteger)index;

/**
 根据索引获取节点
 @param index 索引值 【0 ~ count-1】
 @return 节点对象 [nil 表示操作失败]
 */
-(nullable XZListNode*)nodeAtIndex:(NSInteger)index;

/**
 获取节点所在的索引
 @param node 节点
 @return 节点所在的索引【-1 表示节点没在单链表中】
 */
-(NSInteger)indexOfNode:(XZListNode*)node;

/**
 判断是否有环，存在环则返回成环的入口节点
 @return 环的入口节点 [nil 表示当链表无环]
 */
- (nullable XZListNode*)entryNodeOfLoop;

/**
 判断是否有环
 */
-(BOOL)_XZ_hasLoop;

/**
 反转单链表
 */
- (void)reverseList;

/**
 移除所有节点
 */
- (void)removeAllNodes;

/**
 从头到尾打印链表
 */
-(NSString*)printList;

/**
 单链表中所有节点数
 */
-(NSInteger)sumOfNodes;

/**
 单链表，获取链表的中间点。
 双指针法，一个以一倍速前进，一个以二倍速前进
 */
-(XZListNode*)getMiddleNodeInList;

@end



NS_ASSUME_NONNULL_END
