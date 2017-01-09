//
//  LJFABTestProtocolDispatcher.m
//  LJFABTestProtocolDispatcherDemo
//
//  Created by f.li on 17/1/6.
//  Copyright © 2017年 lijianfei. All rights reserved.
//

#import "LJFABTestProtocolDispatcher.h"
#import <objc/runtime.h>
/**
 如何做到只对Protocol中Selector函数的调用做分发是设计的关键，系统提供有函数
 通过以下方法即可判断Selector是否属于某一Protocol
 */
struct objc_method_description MethodDescriptionForSELInProtocol(Protocol *protocol, SEL sel)
{
    struct objc_method_description description = protocol_getMethodDescription(protocol, sel, YES, YES);
    if (description.types)
    {
        return description;
    }
    description = protocol_getMethodDescription(protocol, sel, NO, YES);
    if (description.types)
    {
        return description;
    }
    return (struct objc_method_description){NULL, NULL};
}

BOOL ProtocolContainSel(Protocol *protocol, SEL sel)
{
    return MethodDescriptionForSELInProtocol(protocol, sel).types ? YES: NO;
}
@interface ImplemertorContext : NSObject

@property (nonatomic, weak) id implemertor;

@end

@implementation ImplemertorContext

@end

@interface LJFABTestProtocolDispatcher ()

@property (nonatomic, strong) Protocol *prococol;
@property (nonatomic, strong) NSArray *implemertors;
@property (nonatomic, strong) NSNumber *indexImplemertor;

@end

@implementation LJFABTestProtocolDispatcher

+ (id)dispatcherProtocol:(Protocol *)protocol
    withIndexImplemertor:(NSNumber *)indexImplemertor
          toImplemertors:(NSArray *)implemertors
{
    return [[LJFABTestProtocolDispatcher alloc] initWithProtocol:protocol withIndexImplemertor:indexImplemertor toImplemertors:implemertors];
}

- (void)dealloc
{
    NSLog(@"ProtocolDispatcher dealloc");
}

- (instancetype)initWithProtocol:(Protocol *)protocol
            withIndexImplemertor:(NSNumber *)indexImplemertor
                  toImplemertors:(NSArray *)implemertors
{
    if (self = [super init])
    {
        self.prococol = protocol;
        self.indexImplemertor = indexImplemertor;
        NSMutableArray *implemertorContexts = [NSMutableArray arrayWithCapacity:implemertors.count];
        [implemertors enumerateObjectsUsingBlock:^(id implemertor, NSUInteger idx, BOOL * _Nonnull stop){
            ImplemertorContext *implemertorContext = [ImplemertorContext new];
            implemertorContext.implemertor = implemertor;
            [implemertorContexts addObject:implemertorContext];
            //  为什么关联个 ProtocolDispatcher 属性？
            // "自释放"，ProtocolDispatcher 并不是一个单例，而是一个局部变量，当implemertor释放时就会触发ProtocolDispatcher释放。
            // key 需要为随机，否则当有两个分发器是，key 会被覆盖，导致第一个分发器释放。所以 key = _cmd 是不行的。
            void *key = (__bridge void *)([NSString stringWithFormat:@"%p",self]);
            objc_setAssociatedObject(implemertor, key, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }];
        self.implemertors = implemertorContexts;
    }
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    //    NSLog(@"%@",NSStringFromSelector(aSelector));
    if (!ProtocolContainSel(self.prococol, aSelector))
    {
        return [super respondsToSelector:aSelector];
    }
    
    for (ImplemertorContext *implemertorContext in self.implemertors)
    {
        if ([implemertorContext.implemertor respondsToSelector:aSelector])
        {
            return YES;
        }
    }
    return NO;
}

/**
 NSObject对象主要通过以下函数响应未实现的Selector函数调用
 
 方案一：动态解析
 + (BOOL)resolveInstanceMethod:(SEL)sel
 + (BOOL)resolveClassMethod:(SEL)sel
 
 方案二：快速转发
 //返回实现了方法的消息转发对象
 - (id)forwardingTargetForSelector:(SEL)aSelector OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0);
 
 方案三：慢速转发
 //函数签名
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
 //函数调用
 - (void)forwardInvocation:(NSInvocation *)anInvocation OBJC_SWIFT_UNAVAILABLE("");
 */

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (!ProtocolContainSel(self.prococol, aSelector))
    {
        return [super methodSignatureForSelector:aSelector];
    }
    
    struct objc_method_description methodDescription = MethodDescriptionForSELInProtocol(self.prococol, aSelector);
    
    return [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
}


/**
 协议分发器Dispatcher可以在该函数中将Protocol中Selector的调用传递给实现者Implemertor，由实现者Implemertor实现具体的Selector函数即可
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = anInvocation.selector;
    if (!ProtocolContainSel(self.prococol, aSelector))
    {
        [super forwardInvocation:anInvocation];
        return;
    }
    
    if (self.indexImplemertor)
    {
        for (NSInteger i = 0; i < [self.implemertors count]; i++)
        {
            ImplemertorContext *implemertorContext = [self.implemertors objectAtIndex:i];
            if (i == self.indexImplemertor.integerValue && [implemertorContext.implemertor respondsToSelector:aSelector])
            {
                [anInvocation invokeWithTarget:implemertorContext.implemertor];
            }
        }
    }
    else
    {
        for (ImplemertorContext *implemertorContext in self.implemertors)
        {
            if ([implemertorContext.implemertor respondsToSelector:aSelector])
            {
                [anInvocation invokeWithTarget:implemertorContext.implemertor];
            }
        }
    }
}

@end
