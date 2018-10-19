//
//  ViewController.m
//  XZSingleList
//
//  Created by kkxz on 2018/10/18.
//  Copyright © 2018年 kkxz. All rights reserved.
//

#import "ViewController.h"
#import "XZSingleList.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    XZSingleList * list = [[XZSingleList alloc] init];
    NSLog(@"初始化：%@",list);
    
    XZListNode * node = [[XZListNode alloc] init];
    node.data = @90;
    
    [list addNode:@1];
    [list addNode:@2];
    [list addNode:@3];
    [list addNode:@4];
    [list addNode:@5];
    [list addNode:node];
    [list addNode:@6];
    [list addNode:@7];
    [list addNode:@8];
    NSLog(@"创建链表 = %zd %@",list.count,list);//链表节点数，及链表
    
    //删除某个节点
    [list removeNode:node];
    NSLog(@"删除某个节点 = %zd %@",list.count,list);
    
    //通过索引删除节点
    XZListNode * indexNode = [list removeNodeAtIndex:2];
    NSLog(@"删除的节点的data值 = %@",indexNode.data);
    NSLog(@"通过索引删除节点 = %zd %@",list.count,list);
    
    //将节点添加到指定索引 - 添加到尾部
    XZListNode * tailNode = [list insertNode:@9 atIndex:7];
    NSLog(@"添加到尾部，节点值 = %@ count = %zd",tailNode.data,list.count);
    
    //将节点添加到指定索引 - 添加到头部
    XZListNode * headNode = [list insertNode:@90 atIndex:0];
    NSLog(@"添加到头部，节点值 = %@ count = %zd",headNode.data,list.count);
    
    //将节点添加到指定索引 - 添加到中间某个位置
    XZListNode * midNode = [list insertNode:@3 atIndex:3];
    NSLog(@"添加到中部某个位置，节点值 = %@ count = %zd",midNode.data,list.count);
    
    //根据索引获取对应的节点
    XZListNode* selectIndexNode = [list nodeAtIndex:0];
     NSLog(@"根据索引获取对应节点，节点值 = %@ count = %zd",selectIndexNode.data,list.count);
    
    //获取节点所在的索引
    XZListNode* sNode = [list nodeAtIndex:9];
    NSInteger sIndex = [list indexOfNode:sNode];
    NSLog(@"获取节点所在索引，索引值 = %zd  节点值 = %@ count = %zd",sIndex,sNode.data,list.count);
    
    //判断链表是否有环
    BOOL isLoop = [list _XZ_hasLoop];
    NSLog(@"%@",isLoop ? @"链表有环":@"链表无环");
    
    //判断链表是否有环，存在则返回成环的入口节点
    XZListNode * loopNode = [list entryNodeOfLoop];
    NSLog(@"%@",loopNode ? @"有环":@"无环");
    
    //链表反转
    [list reverseList];
    NSLog(@"反转链表 = %zd %@",list.count,list);
    
    //从头到尾打印链表
    NSString * printStr =  [list printList];
    NSLog(@"单链表打印 %@",printStr);
    
    //单链表中所有节点数
    NSInteger sumOfNodes = [list sumOfNodes];
    NSLog(@"单链表中所有节点数 = %ld",sumOfNodes);
    
    //删除尾部节点
     XZListNode * tNode = [list removeNodeAtIndex:9];
     NSLog(@"删除尾部节点 = %zd %@",list.count,tNode.data);
    
    printStr =  [list printList];
    NSLog(@"单链表打印 %@",printStr);
    
    //获取链表中间节点
    XZListNode * middleNode = [list getMiddleNodeInList];
    NSLog(@"链表中间节点值 = %@",middleNode.data);
    
    //移除所有节点
    [list removeAllNodes];
    NSLog(@"清空链表 = %zd %@",list.count,list);
    
    
    
}


@end
