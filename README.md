# iOS A/B Test 方案探索
# 引子
公元2016年末，2017年初，某做旅行产品的互联网公司内，产品经理疯狂的提 A/BTest 需求，以至于该司程序猿谈AB色变，邪恶的产品经理令程序猿们闻风丧胆，苦不堪言...咳咳，扯远了。

近期团队做了很多 AB Test 的业务需求，在这种需求日益见多的情况下，我们不得不提升我们的代码组织方式，以适应或更好的在此类需求上维护我们的代码。所以有了本文，本文主要阐述了业务团队在做 AB Test 的一些想法和思路，才疏学浅，不灵赐教。

# A/B Test
## A/B Test 是什么？
既然产品经理在 A/B Test 胯下疯狂的输出，那我们就要弄清楚，什么是 A/BTest？为何产品经理如此痴情于 A/B Test ？

A/B Test 就是为了**同一个目标**制定**两个方案**（比如两个website，app的页面），让**一部分用户**使用 A 方案，**另一部分用户**使用 B 方案，**记录**下用户的使用情况，**看**哪个方案更接近测试想要的结果，并确信该结论在推广到全部流量可信。

请注意上述那段话中的黑体字，这将是 AB Test 的核心价值所在。

其实 A/B Test 就是我们中学上化学实验课时常做的对照试验，把这种对照试验搬到了互联网上，通过改变单一变量的实验组和原来的对照组做对比，通过数据指标对比，看哪种方案能够提高用户体验（转化率）；

## AB Test 的优点有哪些（对产品而言）？
### 优点1. 灰度发布
灰度发布，是指在黑与白之间，能够平滑过渡的一种发布方式。A/B Test就是一种灰度发布方式，让一部分用户继续用A，一部分用户开始用B，如果用户对B没有什么反对意见，那么逐步扩大范围，把所有用户都迁移到B上面来。灰度发布可以保证整体系统的稳定，在初始灰度的时候就可以发现、调整问题，以保证其影响度。

### 优点2. 可逆方案
可逆方案，有点类似于之前的灰度发布，只不过不灰度的控制力更强，当我们发布后发现实验组方案出现了严重的故障，或者对比数据量相差悬殊，那么就完全可以全量切换回原来的对照组，保证了线上环境的稳定，不影响用户的正常使用。

这点，对产品而言就是多了试错的可能，想想在之前App动态化匮乏的时代，App的发布就是嫁出去的女儿泼出去的水，一去不复返，发布了的产品用户更新完就不可能在回退到上一个版本。从这一点开始，产品经理就大爱A/B Test !

### 优点3. 数据驱动
数据驱动，这一点我想至关重要，在目前这种以用户数据为商业土壤的大数据时代，一个产品是以数据驱动，将能够更加铿锵有力的支持这个产品的全线发布，也是产品经理对新方案推进的重要王牌。之前要发布一个新产品，要么美其名曰参考竞品（不反对抄袭，抄袭是赶上竞争对手最快的手段，但是并不是超越的手段），要么脑洞打开，认为某种新的方案或交互体验能带来更多的转化率。这种方法都是没有数据说明的，只能通过项目上线后进行后评估才能确定是否如产品经理所愿真正到达了目标。

通过A/B Test，能在不全量影响线上的正常运转的情况下，通过对照度和试验组的数据对比，在短时间能确定哪种方案的优越，从而让产品的转化率在短时间能得可信性提升。这也正是产品经理说服老板，并彰显其能力价值的精华之处！so，大爱！


# 开发工程师需要关注的事情
## 六问产品经理
在做 AB Test 之前，有几个问题是要问产品经理的：
1. 目标是什么？
2. AB版本是什么?
3. 样本量有多大？
4. 用户如何分流？
5. 测试时间多长？
6. 如何衡量效果？

这其实就是我们上面那段话中加粗文字的重点，当然，有些问题是服务端需要关心的，比如问题3和4。

那么客户端开发需要关心哪些个问题呢？

### 目标是什么？
第一个问题，目标是什么？目的是什么，这是我们需要问的，对客户端而言，A/B Test 就需要客户端维护两套同样业务的代码，这种工作量简单理解就是之前的double，既然会导致工作量翻倍，那就要问清楚，这次做 A/B Test 的目的是什么？评估一下真的值得这样做吗？虽然有时候胳膊拧不过大腿，但或许在你的分析下，某些需求是不需要做 A/B Test 的。例如：竞品已经做了很久方案（你不要告诉我抄都没自信），或者很明显的UI改动是优于之前的方案的，等等。

### A/B Test 版本是什么？测试时间多长？
第二个问题，A/B Test 版本是什么？测试时间多长？其实这两个问题，就是在确认这个 A/B Test 方案什么时候上线，什么时候下线。上下线的时间我们要清楚，因为在这段时间内，我们都需要去维护两套代码，而且在 App Size 这么紧张，大家都在搞瘦身的大环境下，你的安装包的过大或需就是用户从一开始就不选择你们产品的理由！A/B Test 方案，代码有写就有删，何时删代码取决于这个 A/B Test 方案何时下线，删完代码后有多久的时间给 QA 测试工程师去测试，这都是要安排的。

### 如何衡量效果？
对于某些开发每天都要声嘶力竭的说5次以上：“这个（需求）是要算（研发）成本的呀。”这样用力扣研发成本，尽量把价值低收益低的需求砍下去，把收益不明确的需求排到后面去，相当于在输出几乎不变的基础上，节约了2-3个开发工程师。这也是长期维持团队的诀窍，从源头上精简，而不是苛求超人般的程序员。

如何衡量效果，就是来判断这种需求是否是价值低收益低或不明确的项目，我们都想做有价值的东西，而不是随随便便随时准备砍掉的功能，希望产品经理敢想，而且加以思考！

# iOS A/B Test 方案探索
好了，扯完了产品篇，咱们进入正题。
既然原本一套代码有了两种逻辑，或者两种UI样式，就需要从原本的逻辑中拆出来，其必然结果是多了一个if判断语句，那如果判断的地方多了，咱还这样if、if、if、if、i....就太失水准了，常言道：写业务代码，搬得一手好砖是程序员的基本要求。接下来讲下小生的 A/B Test 方案探索历程。
## 方案探索历程
先来大概介绍本次探索的业务背景：
### A/B Test 方案背景介绍
- A 方案 线上方案，全量；
- B 方案，适用于 A 中的一种情况，是 A 方案的子集；
- 非标准 A/B Test，只是过渡，因为 A 方案为全量方案，无法被下掉，B方案为部分A中的；

我们就以 iOS 中典型的 UITabelView 中的 Delegate 和 DataSource 的协议函数分 A/B 方案来说；

### 最基本的函数 A/B
![2017010534065A:BTest_functionA:B2_no.png](http://7xraw1.com1.z0.glb.clouddn.com/2017010534065A:BTest_functionA:B2_no.png)

![201701052172A:BTest_functionA:B_no.png](http://7xraw1.com1.z0.glb.clouddn.com/201701052172A:BTest_functionA:B_no.png)

刚刚说了，A 方案是一个全量方案，所以这里的switch会有一个默认方案。但是这种写法实在是太low了，每一个调用函数中都去判断一次A/B，影响效率暂且不提，维护起来也是坑坑坑，看见第二张图的函数列表页觉得头大，而且也导致了Controller过于庞大，如果再有一个C方案岂不是要炸？所以这种方案不可取。
### 方法选择子 + 字典，缓存式 A/B
![2017010548669A:BTest_Selector+dic1.png](http://7xraw1.com1.z0.glb.clouddn.com/2017010548669A:BTest_Selector+dic1.png)

![201701052186A:BTest_Selector+dic2.png](http://7xraw1.com1.z0.glb.clouddn.com/201701052186A:BTest_Selector+dic2.png)

由于Objective-C 的Runtime 动态特性，我们可以把方法选择子缓存在一个字典中，在需要确定 A/B 方案的调用处判断一次，得到对应方案的方法缓存字典，在调用的时候，只需要去对应的缓存字典中调用就可以了，当然这里需要扩展NSObject类中的`- (id)performSelector:(SEL)aSelector withObject:(id)object;`使其支持多个参数的传递。

```
- (id)fperformSelector:(SEL)selector withObjects:(NSArray *)objects
{
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:selector];
    
    if(methodSignature == nil)
    {
        @throw [NSException exceptionWithName:@"抛异常错误" reason:@"没有这个方法，或者方法名字错误" userInfo:nil];
        return nil;
    }
    else
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        //签名中方法参数的个数，内部包含了self和_cmd，所以参数从第3个开始
        NSInteger  signatureParamCount = methodSignature.numberOfArguments - 2;
        NSInteger requireParamCount = objects.count;
        NSInteger resultParamCount = MIN(signatureParamCount, requireParamCount);
        for (NSInteger i = 0; i < resultParamCount; i++) {
            id  obj = objects[i];
            [invocation setArgument:&obj atIndex:i+2];
        }
        [invocation invoke];
        //返回值处理
        id callBackObject = nil;
        if(methodSignature.methodReturnLength)
        {
            [invocation getReturnValue:&callBackObject];
        }
        return callBackObject;
    }
}

```
这种方案仅仅比上个方案提高了一点，就是我们并没有在每个函数中判断 A/B ，只判断了一次。但仍然解决不了Controller过于庞大，无法优雅的扩展的问题。而且还引入了新的问题，就是在进行Runtime消息转发时的额外开销，和`performSelector`返回值需要转一下类型的尴尬。

### 设计模式之策略模式
![2017010594760OTA_ABTestClass.png](http://7xraw1.com1.z0.glb.clouddn.com/2017010594760OTA_ABTestClass.png)

![201701058434ABstrategy_pattern1.png](http://7xraw1.com1.z0.glb.clouddn.com/201701058434ABstrategy_pattern1.png)

![2017010524744ABstrategy_pattern2.png](http://7xraw1.com1.z0.glb.clouddn.com/2017010524744ABstrategy_pattern2.png)

如图所示，通过策略模式，把需要分 A/B 的方法抽象到一个协议中，然后抽象出一个策略父类去遵循这个协议，其两个A/B子类也遵循这个协议，这样在Controller只需要在判断A/B策略的调用处初始化对应的策略类，通过父类指针去调用子类的协议方法，达到A/B函数的执行。这样采用了面向对象的继承和多态的机制，完成了一次完美的 A/B 函数执行，AB策略可以自由切换，避免了使用多重条件判断，同时满足了开闭原则，对扩展开放（增加新的策略类），对修改关闭。

### Protocol协议分发器，运用于 A/B Test 方案
协议分发可以简单理解为将协议代理交给多个对象实现，类似于多播委托。

Protocol协议代理在开发中应用频繁，开发者经常会遇到一个问题——事件的连续传递。比如，为了隔离封装，开发者可能经常会把tableview的delegate或者datesource抽离出独立的对象，而其它对象（比如VC）需要获取某些delegate事件时，只能通过事件的二次传递。有没有更简单的方法了？协议分发器正好可以派上用场。

既然能实现多播委托消息分发，那么消息分发时，指定的分发的接收者，不就是 A/B Test 的消息分为A/B分发吗?

先给各位看官呈上干货，[LJFABTestProtocolDispatcher](https://github.com/lijianfeigeek/LJFABTestProtocolDispatcher)是一个协议分发器，通过该工具能够轻易实现将协议事件分发给多个实现者，并且能指定调用哪些实现者。比如最常见的UITableViewDelegate和UITableViewDataSource协议，通过[LJFABTestProtocolDispatcher](https://github.com/lijianfeigeek/LJFABTestProtocolDispatcher)能够非常容易发分发给多个对象，而且可以指定A/B方案执行，具体可参考[Demo](https://github.com/lijianfeigeek/LJFABTestProtocolDispatcher)。

#### 原理解析
原理并不复杂， 协议分发器Dispatcher并不实现Protocol协议，其只需将对应的Protocol事件分发给不同的实现者Implemertor。如何实现分发？

NSObject对象主要通过以下函数响应未实现的Selector函数调用
- 方案一：动态解析
    ```
    + (BOOL)resolveInstanceMethod:(SEL)sel;
    + (BOOL)resolveClassMethod:(SEL)sel;
    ```
- 方案二：快速转发
    ```
    //返回实现了方法的消息转发对象
    - (id)forwardingTargetForSelector:(SEL)aSelector OBJC_AVAILABLE(10.5, 2.0,9.0, 1.0);
    ```
- 方案三：慢速转发
    ```
    //函数签名
    - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
    //函数调用
    - (void)forwardInvocation:(NSInvocation *)anInvocation     OBJC_SWIFT_UNAVAILABLE("");
    ```
    
因此，协议分发器Dispatcher可以在该函数中将Protocol中Selector的调用传递给实现者Implemertor，由实现者Implemertor实现具体的Selector函数即可，而现实指定的A/B调用，需要传入所有实现者组织的下标，来指定调用

```
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
```
#### 设计关键
如何做到只对Protocol中Selector函数的调用做分发是设计的关键，系统提供有函数
```
objc_method_description protocol_getMethodDescription(Protocol *p, SEL aSel, BOOL isRequiredMethod, BOOL isInstanceMethod)
```
通过以下方法即可判断Selector是否属于某一Protocol
```
struct objc_method_description MethodDescriptionForSELInProtocol(Protocol *protocol, SEL sel) {
    struct objc_method_description description = protocol_getMethodDescription(protocol, sel, YES, YES);
    if (description.types) {
        return description;
    }
    description = protocol_getMethodDescription(protocol, sel, NO, YES);
    if (description.types) {
        return description;
    }
    return (struct objc_method_description){NULL, NULL};
}
 
BOOL ProtocolContainSel(Protocol *protocol, SEL sel) {
    return MethodDescriptionForSELInProtocol(protocol, sel).types ? YES: NO;
}
```
还有一点，协议分发器并不是一个单例，而是一个局部变量，那如何来防止一个局部变量延迟释放呢？这里使用了“自释放”的一种思想，看源码：
```
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
```
#### 注意事项
协议分发器使用需要了解如何处理带有返回值的函数 ，比如
```
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
```
我们知道，iOS中，函数执行返回的结果存在于寄存器R0中，后执行的会覆盖先执行的结果。因此，当遇到有返回结果的函数时，返回结果以后执行的函数返回结果为最终值。

#### 感谢
Protocol协议分发器，本人并不是首创，也是看了这篇文章[Protocol协议分发器](http://www.olinone.com/?p=643)得到运用于 A/B Test 的灵感，在这里感谢作者和开源社区。

## 业务模块内的 A/B Test 组件探索
随着A/B Test 的代码越来越多，业务模块内的 A/B Test 组件化，无非是为了更方便的上下业务的 A/B Test 代码，提高工作效率，让写代码和删代码变成一件快乐的事情。

关于 iOS 组件化，网上也有很多文章，这里就不炒冷饭了，大家可以搜索一下关于组件化的一些定义和经验。

在整个客户端已经被组件化的今天，不是架构组的业务程序员可不可以尝试来解决一下业务模块内的 A/B Test 组件化呢？iOS 组件化大部分都是围绕 Cocoapods 来展开的，所以在基于 Cocoapods iOS 高度组件化的的框架下， 我们先来问几个技术问题。

### 相同架构的不同静态库是否可合并？
这个问题主要是基于目前整个客户端架构，各个业务线向壳工程提供了自己的静态库，
我们大部分时间（打包时）都会合并不同架构的相同静态库，相同架构的不同静态库是否可合并？

答案是，可以的。

在合并不同架构的相同静态库时，用到以下命令：
- 查看静态库支持的CPU架构
    ```
    lipo -info libname.a(或者libname.framework/libname)
    ```
- 合并静态库
    ```
    lipo -create 静态库存放路径1  静态库存放路径2 ...  -output 整合后存放的路径
    ```
- 静态库拆分
    ```
    lipo 静态库源文件路径 -thin CPU架构名称 -output 拆分后文件存放路径
    ```
    
那么合并相同架构的不同静态库是怎么做的？

静态库文件也称为“文档文件”，它是一些.o文件的集合。在Linux（Unix）中使用工具“ar”对它进行维护管理。它所包含的成员（member）就是若干.o文件。除了.o文件，还有一个一个特殊的成员，它的名字是`__.SYMDEF`。它包含了静态库中所有成员所定义的有效符号（函数名、变量名）。因此，当为库增加了一个成员时，相应的就需要更新成员`__.SYMDEF`，否则所增加的成员中定义的所有的符号将无法被连接程序定位。完成更新的命令是：
```
ranlib libname.a
```
举个例子：
我们有俩个静态库`libFlight.a`和`libHotel.a`，合并成一个`libFlight_Hotel.a`。
* 取出相同架构下的Lib.a。
    首先查看静态库`Flight.a`的架构：
    ```
    lipo -info Flight.a
    ```
    可以看到：
    ```
    input file /Users/f.li/Desktop/相同架构的不同静态库合并/libFlight.a is not a fat file
    Non-fat file: /Users/f.li/Desktop/相同架构的不同静态库合并/libFlight.a is architecture: x86_64
    ```
    libFlight.a is not a fat file 和 libFlight.a is architecture: x86_64
    
    fat file 那么代表这个包是支持多平台的，not a fat file 就是不支持多平台的，架构是x86_64。
    
    当然，如果是 fat file ，我们就需要取出相同平台架构的库。
    ```
    lipo libFlight.a -thin x86_64 -output libFlight.a
    ```
    这样，就会取出 x86_64 架构下的`libFlight.a`。
* 查看库中所包含的文件列表。
    ```
    ar -t /Users/f.li/Desktop/相同架构的不同静态库合并/libFlight.a
    __.SYMDEF SORTED
    Flight.o
    ```
    看到`libFlight.a `有两个文件，`__.SYMDEF SORTED`和`Flight.o`
* 解压出object file（即.o后缀文件）。
    ```
    ~libFlight_o ar xv /Users/f.li/Desktop/libFlight.a
    x - __.SYMDEF SORTED
    x - Flight.o
    ```
    这样，在`libFlight_o`文件夹内，就有了`__.SYMDEF SORTED`和`Flight.o`这个两个文件。
    同样，在`libHotel_o`文件夹内获得`__.SYMDEF SORTED`和`Hotel.o`
* 合并，重新打包。    
    把`__.SYMDEF SORTED`和`Flight.o`，还有`Hotel.o`移动到`libFlight_Hotel_o`文件夹内。把重新打包object file；
    ```
    ar rcs libFlight_Hotel.a /Users/f.li/Desktop/libFlight_Hotel_o/*o
    ```
    这样就得到了`libFlight_Hotel.a`。
* 更新`__.SYMDEF`文件。
    其实，我们是把`Hotel.o`加入了LibFlight.a中，最后，需要更新`__.SYMDEF`文件。
    ```
    ranlib libFlight_Hotel.a
    ```
    如果包含头文件，那么把头文件也放到一个文件内在使用libFlight_Hotel.a的工程中引入就可以了。

但是显然这样做太麻烦。

### Xcode 子工程？
Xcode 子工程，其实是帮助我们在一个工程内配合git submodule 来进行分模块开发。
整理下思路。
* 创建一个 target(Flight_Hotel_Project) 为 Application 的 Xcode 工程为父工程。并git化。
* 创建一个 tagget(Flight_SubProject) 为 Static Library 的 Xcode 工程为子工程，并git化。
* 为父工程添加git submodule。具体参照git。
* 将子工程文件夹拖入父工程。
* 在父工程的 link binary with library 加入Flight_SubProject.a
* 在父工程的 header search paths 中添加头文件搜索路径 `$(SRCROOT)/Flight_SubProject/Flight_SubProject`，其中$(SRCROOT)宏代表你的工程文件目录。
* 编译运行。

这样其实回到了之前架构的一个状态，无法调用解耦，相互依赖严重。

### Cocoapods 的 subspecs 是什么概念？subspec 有自己独立的git仓库吗？是可以理解成pod的子pod吗？
答案是，subspec 不是独立的代码库，只是编译时候分开进行，最后会和pod形成一个产物。

为什么会问 Cocoapods subspecs？因为在基于Cocoapods架构组件化后，业务对外部提供的是静态库类型的pod。

源码类型是subspec，在引入pod时，可以选择引入subspec目录，也可以设置podspec的默认subsepc，subspect之间也可以有依赖关系。

### 最终解决方案是什么？
业务线内部拆分可以做成多个 pod，最后提供一个 pod 依赖所有业务内部的组件 pod，这样不影响外部架构打包，业务线也可以灵活修改。

最后这个依赖所有业务内部组件的pod对外提供的也是一个静态库，业务内部的组件pod不需要提供静态库，但是也会有独立的Git。

当然这种业务内部的 A/B Test 组件化方案目前处于探索阶段，因为目前我们的 A/B Test 的代码量并没有达到需要我们进行拆分的地步，所有这阶段尚处于技术拓展调(yi)研(yin)阶段。

# 小结
关于 iOS A/B Test 的探索目前小生就这么多，A/B Test 对于产品而言确实是一种比较好的方案，尤其是可逆性和数据驱动，当然小生是站在开发的角度上来看待 A/B Test。既然是对产品有利的方案，我们的代码就应该时代潮流，毕竟技术是为业务服务的。

前段时间在看 sunny 直播时，谈到了 iOS 开发的进阶速度
> 纯日常开发 < 纯看书、博客 < 自己试验、Demo < 写博客 < 系统性分享和讨论 < 提供完整的开源方案

之前自己的进阶速度仅仅到写博客的分段，最近这半年在团队中发起了技术分享了和团队博客的浪潮，希望能够向系统性分享、讨论和完整的开源方案这两个高分段冲分，本次结合最近的业务和自身的一些想法和实践，完成了一次冲分尝试，希望在冲分的路上越战越勇！
