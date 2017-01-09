//
//  LJFABTestProtocolDispatcher.h
//  LJFABTestProtocolDispatcherDemo
//
//  Created by f.li on 17/1/6.
//  Copyright © 2017年 lijianfei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ABTestProtocolDispatcher(__protocol__,index,...)  \
    [LJFABTestProtocolDispatcher dispatcherProtocol:@protocol(__protocol__)  \
                      withIndexImplemertor:index \
  toImplemertors:[NSArray arrayWithObjects:__VA_ARGS__, nil]]

@interface LJFABTestProtocolDispatcher : NSObject

/**
 协议分发器
 @param protocol 遵循的协议;
 @param indexImplemertor AB Test 需要执行的协议实现实例数组下标;
        若传入 对应的 NSNumber 数字, 则调用改实现实例的协议方法;
        若传入 nil,则调用全部的遵循协议的实现实例
 @param implemertors 所有需要遵循协议的实现实例;
 @return 协议分发器;
 */
+ (id)dispatcherProtocol:(Protocol *)protocol
    withIndexImplemertor:(NSNumber *)indexImplemertor
          toImplemertors:(NSArray *)implemertors;

@end
