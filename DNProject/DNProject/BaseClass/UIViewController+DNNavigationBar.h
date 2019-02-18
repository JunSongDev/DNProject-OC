//
//  UIViewController+DNNavigationBar.h
//  DNProject
//
//  Created by zjs on 2019/2/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (DNNavigationBar)

@property (nonatomic, assign) UIBarStyle dn_barStyle;
@property (nonatomic, assign) CGFloat    dn_barAlpha;
@property (nonatomic, assign) BOOL       dn_shadowHidden;
@property (nonatomic, assign) BOOL       dn_enablePopGesture;

@property (nonatomic, strong) UIColor *dn_backgroundColor;
@property (nonatomic, strong) UIColor *dn_shadowColor;
@property (nonatomic, strong) UIColor *dn_tintColor;
@property (nonatomic, strong) UIColor *dn_titleColor;

@property (nonatomic, strong) UIFont  *dn_titleFont;

@property (nonatomic, strong) UIImage *dn_backgroundImage;
@end

NS_ASSUME_NONNULL_END
