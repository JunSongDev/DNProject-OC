//
//  DNNavigationController.m
//  DNProject
//
//  Created by zjs on 2019/2/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNNavigationController.h"
#import "DNNavigationBar.h"
#import "UIViewController+DNNavigationBar.h"

@interface DNNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIViewControllerTransitionCoordinator>

@property (nonatomic, strong) UIViewController *popVc;
//@property (nonatomic, copy) NSKeyValueObservation *frameObserver;
@end

@implementation DNNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(handleinteractivePopGesture:)];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
}

- (void)handleinteractivePopGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    
    UIViewController *fromVc = [self.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc   = [self.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    if (self.transitionCoordinator && fromVc && toVc) {
        
        if (gesture.state == UIGestureRecognizerStateChanged) {
            
            self.navigationBar.tintColor = [self average:fromVc.dn_tintColor
                                                 toColor:toVc.dn_tintColor
                                                 percent:self.transitionCoordinator.percentComplete];
        }
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    self.popVc = self.topViewController;
    
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    
    UIViewController *topVC = self.topViewController;
    if (topVC) {
        
    }
    return viewController;
}

#pragma mark -- Private Methods
- (void)setupNavigationBar {
    
    [self.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = UIImage.new;
    [self dn_setupSubviews];
}

- (void)dn_setupSubviews {
    
    if (self.dn_superView) {
        
        if (!self.naviBar.superview) {
            
            [self.dn_superView insertSubview:self.naviBar atIndex:0];
        }
    }
}

- (void)dn_layoutSubviews {
    
}

- (UIColor *)average:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent {
    
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    CGFloat red = fromRed + (toRed - fromRed) * percent;
    CGFloat green = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat blue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat alpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

//- (void)showViewController:(UIViewController *)viewController coordinator:()coordinator {
//
//
//}

- (void)showTempBar:(UIViewController *)fromVc toVc:(UIViewController *)toVc {
    
    [UIView setAnimationsEnabled:NO];
    self.naviBar.alpha = 0;
    // from
    [fromVc.view addSubview:self.fromBar];
    self.fromBar.frame = [self fakerBarFrame:fromVc];
    [self.fromBar setNeedsLayout];
    [self.fromBar dn_updateBarShadow:fromVc];
    [self.fromBar dn_updateBarBackground:fromVc];
    // to
    [toVc.view addSubview:self.toBar];
    self.toBar.frame = [self fakerBarFrame:toVc];
    [self.toBar setNeedsLayout];
    [self.toBar dn_updateBarShadow:toVc];
    [self.toBar dn_updateBarBackground:toVc];
    [UIView setAnimationsEnabled:YES];
}

- (void)clearTempFakeBar {
    
    self.naviBar.alpha = 1;
    [self.fromBar removeFromSuperview];
    [self.toBar removeFromSuperview];
}

- (CGRect)fakerBarFrame:(UIViewController *)viewController {
    
    if (self.dn_superView) {
        CGRect frame = [self.navigationBar convertRect:self.dn_superView.frame toView:viewController.view];
        frame.origin.x = viewController.view.frame.origin.x;
        return frame;
    } else {
        
        return self.navigationBar.frame;
    }
}

- (void)resetButtonLabels:(UIView *)subview {
    
    NSString *className = [[[subview classForCoder] description] stringByReplacingOccurrencesOfString:@"_" withString:@""];
    if ([className isEqualToString:@"UIButtonLabel"]) {
        
        subview.alpha = 1;
    } else {
        
        if (subview.subviews.count > 0) {
            
            for (UIView *view in subview.subviews) {
                
                [self resetButtonLabels:view];
            }
        }
    }
}

#pragma mark -- UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    //UIViewControllerTransitionCoordinator transitionCoordinator = self.transitionCoordinator;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (!animated) {
        [self dn_updateNavigationBar:viewController];
        [self clearTempFakeBar];
    }
    self.popVc = nil;
}

#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    UIViewController *topVc = self.topViewController;
    if (topVc) {
        return topVc.dn_enablePopGesture;
    }
    return YES;
}

#pragma mark -- Setter
- (DNNavigationBar *)naviBar {
    
    if (!_naviBar) {
        _naviBar = [[DNNavigationBar alloc] init];
    }
    return _naviBar;
}

- (DNNavigationBar *)fromBar {
    
    if (!_fromBar) {
        _fromBar = [[DNNavigationBar alloc] init];
    }
    return _fromBar;
}

- (DNNavigationBar *)toBar {
    
    if (!_toBar) {
        _toBar = [[DNNavigationBar alloc] init];
    }
    return _toBar;
}

- (UIView *)dn_superView {
    
    if (!_dn_superView) {
        _dn_superView = self.navigationBar.subviews.firstObject;
    }
    return _dn_superView;
}

@end

@implementation DNNavigationController (Extra)

#pragma mark -- Public Methods
- (void)dn_updateNavigationBar:(UIViewController *)viewController {
    
    [self dn_updateNavigationBarTint:viewController ignoreTintColor:NO];
    [self dn_updateNavigationBarShadow:viewController];
    [self dn_updateNavigationBarBackground:viewController];
}

- (void)dn_updateNavigationBarTint:(UIViewController *)viewController ignoreTintColor:(BOOL)ignoreTintColor {
    
    if (viewController != self.topViewController) {
        return;
    }
    [UIView setAnimationsEnabled:NO];
    self.navigationBar.barStyle = viewController.dn_barStyle;
    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName:viewController.dn_titleColor,
                                          NSFontAttributeName:viewController.dn_titleFont
                                          };
    self.navigationBar.titleTextAttributes = titleTextAttributes;
    if (!ignoreTintColor) {
        
        self.navigationBar.tintColor = viewController.dn_tintColor;
    }
    [UIView setAnimationsEnabled:YES];
}

- (void)dn_updateNavigationBarBackground:(UIViewController *)viewController {
    
    if (viewController != self.topViewController) {
        return;
    }
    [self.naviBar dn_updateBarBackground:viewController];
}

- (void)dn_updateNavigationBarShadow:(UIViewController *)viewController {
    
    if (viewController != self.topViewController) {
        return;
    }
    [self.naviBar dn_updateBarShadow:viewController];
}
@end
