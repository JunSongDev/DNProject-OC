//
//  DNNavigationBar.m
//  DNProject
//
//  Created by zjs on 2019/2/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNNavigationBar.h"
#import "UIViewController+DNNavigationBar.h"

@implementation DNNavigationBar

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self initializationSubviews];
    }
    return self;
}

#pragma mark -- 添加控件
- (void)initializationSubviews {
    
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.dn_backgroundEffectView];
    [self addSubview:self.dn_backgroundImageView];
    [self addSubview:self.dn_shadowImageView];
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.dn_backgroundEffectView.frame = self.bounds;
    self.dn_backgroundImageView.frame = self.bounds;
    self.dn_shadowImageView.frame = CGRectMake(0,
                                               self.bounds.size.height - 0.5,
                                               self.bounds.size.width, 0.5);
}

#pragma mark -- Target Methods
- (void)dn_updateBarBackground:(UIViewController *)viewController {
    
    self.dn_backgroundEffectView.subviews.lastObject.backgroundColor = viewController.dn_backgroundColor;
    
    self.dn_backgroundImageView.image = viewController.dn_backgroundImage;
    
    if (viewController.dn_backgroundImage != nil) {
        
        for (UIView *subView in self.dn_backgroundEffectView.subviews) {
            
            subView.alpha = 0;
        }
    } else {
        
        for (UIView *subView in self.dn_backgroundEffectView.subviews) {
            
            subView.alpha = viewController.dn_barAlpha;
        }
    }
    self.dn_backgroundImageView.alpha = viewController.dn_barAlpha;
    self.dn_shadowImageView.alpha     = viewController.dn_barAlpha;
}

- (void)dn_updateBarShadow:(UIViewController *)viewController {
    
    self.dn_shadowImageView.hidden = viewController.dn_shadowHidden;
    self.dn_shadowImageView.backgroundColor = viewController.dn_shadowColor;
}

#pragma mark -- Getter
- (UIImageView *)dn_backgroundImageView {
    
    if (!_dn_backgroundImageView) {
     
        _dn_backgroundImageView.userInteractionEnabled = false;
        _dn_backgroundImageView.contentScaleFactor = 1;
        _dn_backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        _dn_backgroundImageView.backgroundColor = UIColor.clearColor;
    }
    return _dn_backgroundImageView;
}

- (UIImageView *)dn_shadowImageView {
    
    if (!_dn_shadowImageView) {
        
        _dn_shadowImageView.userInteractionEnabled = false;
        _dn_shadowImageView.contentScaleFactor = 1;
    }
    return _dn_shadowImageView;
}

- (UIVisualEffectView *)dn_backgroundEffectView {
    
    if (!_dn_backgroundEffectView) {
        UIBlurEffect *effect     = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _dn_backgroundEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _dn_backgroundEffectView.userInteractionEnabled = false;
    }
    return _dn_backgroundEffectView;
}
@end
