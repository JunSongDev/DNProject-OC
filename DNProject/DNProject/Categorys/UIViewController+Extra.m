//
//  UIViewController+Extra.m
//  DNProject
//
//  Created by zjs on 2019/3/7.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "UIViewController+Extra.h"
#import <objc/runtime.h>

static char *rootScrollViewKey = "rootScrollViewKey";

@implementation UIViewController (Extra)

- (void)setRootScrollView:(UIScrollView *)rootScrollView {
    
    objc_setAssociatedObject(self, rootScrollViewKey, rootScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollView *)rootScrollView {
    
    return objc_getAssociatedObject(self, rootScrollViewKey);
}
@end
