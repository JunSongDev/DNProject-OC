//
//  DNNavigationBar.h
//  DNProject
//
//  Created by zjs on 2019/2/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNNavigationBar : UIView

@property (nonatomic, strong) UIImageView *dn_backgroundImageView;
@property (nonatomic, strong) UIImageView *dn_shadowImageView;

@property (nonatomic, strong) UIVisualEffectView *dn_backgroundEffectView;

- (void)dn_updateBarBackground:(UIViewController *)viewController;

- (void)dn_updateBarShadow:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
