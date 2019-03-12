//
//  Documents.h
//  DNProject
//
//  Created by zjs on 2019/2/27.
//  Copyright © 2019 zjs. All rights reserved.
//

#ifndef Documents_h
#define Documents_h

/*
 
 1. 我们说的Objective-C是动态运行时语言是什么意思
    (1)、动态类型。如id类型。实际上静态类型因为其固定性和可预知性而使用得更加广泛。静态类型是强类型，而动态类型属于弱类型。运行时决定接收者。
    (2)、动态绑定。让代码在运行时判断需要调用什么方法，而不是在编译时。
    (3)、动态载入。让程序在运行时添加代码模块以及其他资源。
 
 
 2. 为什么代理要用weak？代理的delegate和dataSource有什么区别？block和代理的区别
 
 weak 用法：weak是弱引用，用weak描述修饰或者所引用对象的计数器不会加一，并且会在引用的对象被释放的时候自动被设置为nil，大大避免了野指针访问坏内存引起崩溃的情况，另外weak还可以用于解决循环引用
 
 weak 原理：(1)、初始化时：runtime 会调用 objc_initWeak 函数，初始化一个新的 weak 指针指向对象的地址
           (2)、添加引用时：objc_initWeak 函数会调用 objc_storeWeak() 函数来更新指针指向，创建对应的弱引用表
           (3)、释放时，调用 clearDeallocating 函数。clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，然后遍历这个数组把其中的数据设为nil，最后把这个 entry 从 weak 表中删除，最后清理对象的记录
 
 3. 属性的实质是什么？包括哪几个部分？属性默认的关键字都有哪些？@dynamic关键字和@synthesize关键字是用来做什么的
 
 
 4.
 
 
 5.
 
 
 6.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 */


#endif /* Documents_h */
