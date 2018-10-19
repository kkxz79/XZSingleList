//
//  XZListNode.h
//  XZSingleList
//
//  Created by kkxz on 2018/10/18.
//  Copyright © 2018年 kkxz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZListNode : NSObject
//数据对象，id类型
@property (strong, nonatomic) id data;
@property (nullable,strong,nonatomic)XZListNode * next;
@end

NS_ASSUME_NONNULL_END
