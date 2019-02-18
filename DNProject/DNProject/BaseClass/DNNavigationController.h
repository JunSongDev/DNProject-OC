//
//  DNNavigationController.h
//  DNProject
//
//  Created by zjs on 2019/2/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  DNNavigationBar;

@interface DNNavigationController : UINavigationController

@property (nonatomic, strong) DNNavigationBar *naviBar;
@property (nonatomic, strong) DNNavigationBar *fromBar;
@property (nonatomic, strong) DNNavigationBar *toBar;

@property (nonatomic, strong) UIView *dn_superView;

@end

@interface DNNavigationController (Extra)

- (void)dn_updateNavigationBar:(UIViewController *)viewController;

- (void)dn_updateNavigationBarTint:(UIViewController *)viewController ignoreTintColor:(BOOL)ignoreTintColor;

- (void)dn_updateNavigationBarBackground:(UIViewController *)viewController;

- (void)dn_updateNavigationBarShadow:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
