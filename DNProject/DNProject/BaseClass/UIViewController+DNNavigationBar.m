//
//  UIViewController+DNNavigationBar.m
//  DNProject
//
//  Created by zjs on 2019/2/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "UIViewController+DNNavigationBar.h"
#import "DNNavigationController.h"
#import <objc/runtime.h>

static NSString *barStyleKey = @"DNNavigationBarKeys_barStyle";
static NSString *backgroundColorKey = @"DNNavigationBarKeys_backgroundColor";
static NSString *backgroundImageKey = @"DNNavigationBarKeys_backgroundImage";
static NSString *tintColorKey = @"DNNavigationBarKeys_tintColor";
static NSString *barAlphaKey = @"DNNavigationBarKeys_barAlpha";
static NSString *titleColorKey = @"DNNavigationBarKeys_titleColor";
static NSString *titleFontKey = @"DNNavigationBarKeys_titleFont";
static NSString *shadowHiddenKey = @"DNNavigationBarKeys_shadowHidden";
static NSString *shadowColorKey = @"DNNavigationBarKeys_shadowColor";
static NSString *enablePopGestureKey = @"DNNavigationBarKeys_enablePopGesture";

@implementation UIViewController (DNNavigationBar)

#pragma mark -- Target Methods
- (void)dn_setNeedsNavigationBarUpdate {
    
    DNNavigationController *navigation = (DNNavigationController *)self.navigationController;
    if (navigation) {
        
        
    }
}

- (void)dn_setNeedsNavigationBarTintUpdate {
    
    DNNavigationController *navigation = (DNNavigationController *)self.navigationController;
    if (navigation) {
        
        
    }
}

- (void)dn_setNeedsNavigationBarBackgroundUpdate {
    
    DNNavigationController *navigation = (DNNavigationController *)self.navigationController;
    if (navigation) {
        
        
    }
}

- (void)dn_setNeedsNavigationBarShadowUpdate {
    
    DNNavigationController *navigation = (DNNavigationController *)self.navigationController;
    if (navigation) {
        
        
    }
}

#pragma mark -- Setter
- (void)setDn_barStyle:(UIBarStyle)dn_barStyle {
    
    NSNumber *barStyle = [NSNumber numberWithInteger:dn_barStyle];
    objc_setAssociatedObject(self, &barStyleKey, barStyle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setDn_barAlpha:(CGFloat)dn_barAlpha {
    
    NSNumber *barAlpha = [NSNumber numberWithFloat:dn_barAlpha];
    objc_setAssociatedObject(self, &barAlphaKey, barAlpha, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setDn_shadowHidden:(BOOL)dn_shadowHidden {
    
    NSNumber *shadowHidden = [NSNumber numberWithBool:dn_shadowHidden];
    objc_setAssociatedObject(self, &shadowHiddenKey, shadowHidden, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setDn_enablePopGesture:(BOOL)dn_enablePopGesture {
    
    NSNumber *enablePopGesture = [NSNumber numberWithBool:dn_enablePopGesture];
    objc_setAssociatedObject(self, &enablePopGestureKey, enablePopGesture, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setDn_backgroundColor:(UIColor *)dn_backgroundColor {
    
    objc_setAssociatedObject(self, &backgroundColorKey, dn_backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDn_shadowColor:(UIColor *)dn_shadowColor {
    
    objc_setAssociatedObject(self, &shadowColorKey, dn_shadowColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDn_tintColor:(UIColor *)dn_tintColor {
    
    objc_setAssociatedObject(self, &tintColorKey, dn_tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDn_titleColor:(UIColor *)dn_titleColor {
    
    objc_setAssociatedObject(self, &titleColorKey, dn_titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDn_titleFont:(UIFont *)dn_titleFont {
    
    objc_setAssociatedObject(self, &titleFontKey, dn_titleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDn_backgroundImage:(UIImage *)dn_backgroundImage {
    
    objc_setAssociatedObject(self, &backgroundImageKey, dn_backgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -- Getter
- (UIBarStyle)dn_barStyle {
    
    NSNumber *barStyle = objc_getAssociatedObject(self, &barStyleKey);
    return barStyle.integerValue;
}

- (CGFloat)dn_barAlpha {
    
    NSNumber *barAlpha = objc_getAssociatedObject(self, &barAlphaKey);
    return barAlpha.floatValue;
}

- (BOOL)dn_shadowHidden {
    
    NSNumber *barAlpha = objc_getAssociatedObject(self, &shadowHiddenKey);
    return barAlpha.boolValue;
}

- (BOOL)dn_enablePopGesture {
    
    NSNumber *enablePopGesture = objc_getAssociatedObject(self, &enablePopGestureKey);
    return enablePopGesture.boolValue;
}

- (UIColor *)dn_backgroundColor {
    
    return objc_getAssociatedObject(self, &backgroundColorKey);
}

- (UIColor *)dn_shadowColor {
    
    return objc_getAssociatedObject(self, &shadowColorKey);
}

- (UIColor *)dn_tintColor {
    
    return objc_getAssociatedObject(self, &tintColorKey);
}

- (UIColor *)dn_titleColor {
    
    return objc_getAssociatedObject(self, &titleColorKey);
}

- (UIFont *)dn_titleFont {
    
    return objc_getAssociatedObject(self, &titleFontKey);
}

- (UIImage *)dn_backgroundImage {
    
    return objc_getAssociatedObject(self, &backgroundImageKey);
}
@end
