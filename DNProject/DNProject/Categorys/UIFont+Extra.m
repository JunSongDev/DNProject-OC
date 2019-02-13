//
//  UIFont+Extra.m
//  DNProject
//
//  Created by zjs on 2019/1/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "UIFont+Extra.h"
#import <objc/runtime.h>

@implementation UIFont (Extra)

+ (void)load {
    [self swizzleClassMethod:@selector(systemFontOfSize:) newMethod:@selector(dn_systemFontOfSize:)];
    [self swizzleClassMethod:@selector(fontWithName:size:) newMethod:@selector(dn_fontWithName:fontSize:)];
    [self swizzleClassMethod:@selector(boldSystemFontOfSize:) newMethod:@selector(dn_boldSystemFontOfSize:)];
    [self swizzleClassMethod:@selector(italicSystemFontOfSize:) newMethod:@selector(dn_italicSystemFontOfSize:)];
}

// 适配字体大小
+ (UIFont *)dn_systemFontOfSize:(CGFloat)fontSize {
    
    UIFont *newFont = [UIFont dn_systemFontOfSize:(fontSize * UIScreen.mainScreen.bounds.size.width/375.0)];
    return newFont;
}

// 粗体
+ (UIFont *)dn_boldSystemFontOfSize:(CGFloat)fontSize {
    
    UIFont *newFont = [UIFont dn_boldSystemFontOfSize:(fontSize * UIScreen.mainScreen.bounds.size.width/375.0)];
    return newFont;
}

// 斜体
+ (UIFont *)dn_italicSystemFontOfSize:(CGFloat)fontSize {
    
    UIFont *newFont = [UIFont dn_italicSystemFontOfSize:(fontSize * UIScreen.mainScreen.bounds.size.width/375.0)];
    return newFont;
}

// 字体 + 大小
+ (UIFont *)dn_fontWithName:(NSString *)fontName fontSize:(CGFloat)fontSize {
    
    UIFont *newFont = [UIFont dn_fontWithName:fontName
                                     fontSize:(fontSize * UIScreen.mainScreen.bounds.size.width/375.0)];
    return newFont;
}

+ (void)swizzleClassMethod:(SEL)oldMethod newMethod:(SEL)newMethod {
    
    // 获取将要被替换的类方法
    Method sys_sysMethod = class_getClassMethod([self class], oldMethod);
    // 获取将要替换的类方法
    Method dns_sysMethod = class_getClassMethod([self class], newMethod);
    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
    method_exchangeImplementations(dns_sysMethod, sys_sysMethod);
}

@end
