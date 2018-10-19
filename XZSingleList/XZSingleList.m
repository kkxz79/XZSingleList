//
//  XZSingleList.m
//  XZSingleList
//
//  Created by kkxz on 2018/10/18.
//  Copyright © 2018年 kkxz. All rights reserved.
//

#import "XZSingleList.h"
#import <pthread.h>
static NSString * const xz_k_hasALoop_des = @"XZSingleList exist a loop";

@interface XZSingleList()
@property (nonatomic,strong)XZListNode * head;
@property (nonatomic,strong)XZListNode * tail;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign)pthread_mutex_t mutex;
@end

@implementation XZSingleList
-(void)dealloc
{
    pthread_mutex_destroy(&_mutex);
}

-(instancetype)init
{
    if(self = [super init]){
        _head = [[XZListNode alloc] init];
        _head.data = [NSNull null];
        _head.next = nil;
        _tail = _head;
        //递归锁
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
        pthread_mutex_init(&_mutex, &attr);
        pthread_mutexattr_destroy(&attr);
        
    }
    return self;
}



//向链表添加节点
-(XZListNode *)addNode:(id)node
{
    NSAssert(![self _XZ_hasLoop], xz_k_hasALoop_des);
    pthread_mutex_lock(&_mutex);
    XZListNode * temNode = node;
    if(![node isKindOfClass:[XZListNode class]]){
        temNode = [[XZListNode alloc] init];
        temNode.data = node;
        temNode.next = nil;
    }
    _tail.next = temNode;
    _tail = temNode;
    _count++;
    pthread_mutex_unlock(&_mutex);
    return temNode;
}

//删除某个节点
-(void)removeNode:(XZListNode *)node
{
    NSAssert(![self _XZ_hasLoop], xz_k_hasALoop_des);
    NSParameterAssert(!(!node || ![node isKindOfClass:[XZListNode class]]));
    pthread_mutex_lock(&_mutex);
    
    if(!node
       || ![node isKindOfClass:[XZListNode class]]
       || _count == 0){
        pthread_mutex_unlock(&_mutex);
        return;
    }
    
    XZListNode * p = _head;
    while (p) {
        if([node isEqual:p.next]){
            p.next = node.next;
            node.next = nil;//保证被移除的节点不携带单链表的信息
            if([node isEqual:_tail]){
                _tail = p;
            }
            _count--;
            break;
        }
        else{
            p = p.next;
        }
    }
    pthread_mutex_unlock(&_mutex);
}

//TODO:通过索引删除节点
- (nullable XZListNode*)removeNodeAtIndex:(NSInteger)index
{
    NSAssert(![self _XZ_hasLoop],xz_k_hasALoop_des);
    pthread_mutex_lock(&_mutex);
    NSParameterAssert(!(index < 0 || index >= _count));
    
    if(index < 0 || index >= _count || _count == 0){
        pthread_mutex_unlock(&_mutex);
        return nil;
    }
    
    NSInteger i = 0;
    XZListNode * node = nil;
    XZListNode * p = _head;
    while (p) {
        if(i == index){
            node = p.next;
            p.next = node.next;
            if(index == (_count-1)){
                _tail = p;
            }
            _count--;
            break;
        }
        else{
            i++;
            p = p.next;
        }
    }
    node.next = nil;//保证被移除的节点不携带单链表的信息
    pthread_mutex_unlock(&_mutex);
    return node;
}

//TODO:将节点添加到指定索引
- (nullable XZListNode*)insertNode:(id)node atIndex:(NSInteger)index
{
    NSAssert(![self _XZ_hasLoop], xz_k_hasALoop_des);
    pthread_mutex_lock(&_mutex);
    NSParameterAssert(!(!node || index < 0 || index > _count));
    
    if (!node || index < 0 || index > _count) {//数据不合法
        pthread_mutex_unlock(&_mutex);
        return nil;
    }
    
    XZListNode * temNode = node;
    if(![node isKindOfClass:[XZListNode class]]){
        temNode = [[XZListNode alloc] init];
        temNode.data = node;
        temNode.next = nil;
    }
    
    if(index == _count){
        _tail.next = temNode;
        _tail = temNode;
        _count++;
        pthread_mutex_unlock(&_mutex);
        return temNode;
    }
    
    XZListNode* p = _head;
    NSInteger i = 0;
    while (p) {
        if(i == index){
            temNode.next = p.next;
            p.next = temNode;
            _count++;
            pthread_mutex_unlock(&_mutex);
            return temNode;
        }
        else{
            i++;
            p = p.next;
        }
    }
    pthread_mutex_unlock(&_mutex);
    return nil;
}

//TODO:根据索引获取节点
- (XZListNode *)nodeAtIndex:(NSInteger)index
{
    NSAssert(![self _XZ_hasLoop], xz_k_hasALoop_des);
    pthread_mutex_lock(&_mutex);
    NSParameterAssert(!(index <0 || index >= _count));
    
    if(index<0 || index >=_count || _count == 0){
        pthread_mutex_unlock(&_mutex);
        return nil;
    }
    
    if(index == (_count-1)){
        XZListNode* temNode = _tail;
        pthread_mutex_unlock(&_mutex);
        return temNode;
    }
    
    XZListNode* p = _head.next;
    NSInteger i = 0;
    while (p) {
        if(i == index){
            break;
        }
        else{
            i++;
            p = p.next;
        }
    }
    pthread_mutex_unlock(&_mutex);
    return p;
}

//TODO:获取节点所在的索引
-(NSInteger)indexOfNode:(XZListNode *)node
{
    NSAssert(![self _XZ_hasLoop], xz_k_hasALoop_des);
    NSParameterAssert(!(!node || ![node isKindOfClass:[XZListNode class]]));
    pthread_mutex_lock(&_mutex);
    
    if(!node || ![node isKindOfClass:[XZListNode class]] || _count == 0){
        pthread_mutex_unlock(&_mutex);
        return -1;
    }
    
    if([node isEqual:_tail]){
        NSInteger temCount = _count - 1;
        pthread_mutex_unlock(&_mutex);
        return temCount;
    }
    
    XZListNode* p = _head.next;
    NSInteger i = 0;
    while (p) {
        if([node isEqual:p]){
            pthread_mutex_unlock(&_mutex);
            return i;
        }
        else{
            i++;
            p = p.next;
        }
    }
    pthread_mutex_unlock(&_mutex);
    return -1;
}

//TODO:判断链表是否有环，存在则返回成环的入口节点
-(XZListNode *)entryNodeOfLoop
{
    pthread_mutex_lock(&_mutex);
    if(_count < 2){
        pthread_mutex_unlock(&_mutex);
        return nil;
    }
    
    XZListNode* slow = _head.next;
    XZListNode* fast = _head.next;
    while (fast != nil && fast.next != nil) {
        slow = slow.next;
        fast = fast.next.next;
        if([slow isEqual:fast]){
            XZListNode* p = _head.next;
            XZListNode* q = slow;
            while (p != q) {
                p = p.next;
                q = q.next;
            }
            if([p isEqual:q]){
                pthread_mutex_unlock(&_mutex);
                return q;
            }
        }
    }
    pthread_mutex_unlock(&_mutex);
    return nil;
}

//TODO:判断链表是否有环
-(BOOL)_XZ_hasLoop
{
    pthread_mutex_lock(&_mutex);
    if(_count<2){
        pthread_mutex_unlock(&_mutex);
        return NO;
    }
    
    XZListNode * slow = _head.next;
    XZListNode * fast = _head.next;
    while (fast !=nil && fast.next != nil) {
        slow = slow.next;
        fast = fast.next.next;
        if([slow isEqual:fast]){
            pthread_mutex_unlock(&_mutex);
            return YES;
        }
    }
    pthread_mutex_unlock(&_mutex);
    return NO;
}

//TODO:反转单链表
-(void)reverseList
{
    NSAssert(![self _XZ_hasLoop], xz_k_hasALoop_des);
    pthread_mutex_lock(&_mutex);
    
    if(_count < 2){
        pthread_mutex_unlock(&_mutex);
        return;
    }
    
    XZListNode* p;
    XZListNode* q;
    p = _head.next.next;
    while (p.next != nil) {
        q = p.next;
        p.next = q.next;
        q.next = _head.next.next;
        _head.next.next = q;
    }
    
    if(p){
        _tail = _head.next;
        p.next = _head.next;//成环
        _head.next = p.next.next;
        p.next.next = nil;//断环
    }
    
    pthread_mutex_unlock(&_mutex);
}

//TODO:移除所有节点
-(void)removeAllNodes
{
    NSAssert(![self _XZ_hasLoop], xz_k_hasALoop_des);
    pthread_mutex_lock(&_mutex);
    
    if(_count == 0){
        pthread_mutex_unlock(&_mutex);
        return;
    }
    
    XZListNode* p = _head;
    XZListNode* q = p.next;
    while (q) {
        p.next = nil;
        p = q;
        q = p.next;
        _count--;
    }
    _tail = _head;
    pthread_mutex_unlock(&_mutex);
}

-(NSString *)description
{
    //重写
    NSAssert(![self _XZ_hasLoop], xz_k_hasALoop_des);
    pthread_mutex_lock(&_mutex);
    
    XZListNode* p = _head.next;
    NSMutableString* prf = [[NSMutableString alloc] initWithFormat:@"【%zd】|",_count];
    while (p) {
        [prf appendString:[NSString stringWithFormat:@" -> %@ ",p.data]];
        p = p.next;
    }
    [prf appendFormat:@" | [Teail: data %@ next %@]",_tail.data,_tail.next];//尾部信息
    pthread_mutex_unlock(&_mutex);
    return prf.copy;
    
}

//TODO:从头到尾打印单链表
-(NSString*)printList
{
    NSAssert(![self _XZ_hasLoop], xz_k_hasALoop_des);
    pthread_mutex_lock(&_mutex);
    
    XZListNode* p = _head.next;
    NSMutableString* prf = [[NSMutableString alloc] init];
    while (p) {
        [prf appendString:[NSString stringWithFormat:@" -> %@ ",p.data]];
        p = p.next;
    }
    pthread_mutex_unlock(&_mutex);
    return prf.copy;
}

//TODO:求链表中所有节点数
-(NSInteger)sumOfNodes
{
    NSAssert(![self _XZ_hasLoop], xz_k_hasALoop_des);
    pthread_mutex_lock(&_mutex);
    NSInteger count = 0;
    XZListNode* p = _head.next;
    while (p) {
        p = p.next;
        count++;
    }
    pthread_mutex_unlock(&_mutex);
    return count;
}

//TODO：求单链表的中间节点
-(XZListNode *)getMiddleNodeInList
{
    NSAssert(![self _XZ_hasLoop], xz_k_hasALoop_des);
    pthread_mutex_lock(&_mutex);
    
    XZListNode * slow = _head.next;
    XZListNode * fast = _head.next;
    
    while (fast !=nil && fast.next != nil) {
        slow = slow.next;
        fast = fast.next.next;
    }
    return slow;
}

@end
