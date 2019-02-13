//
//  WKWebView+Extra.m
//  DNProject
//
//  Created by zjs on 2019/1/16.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "WKWebView+Extra.h"

@implementation WKWebView (Extra)

- (void)dn_removeBackgroundShadow {
    
    for (UIView * subView in [self.scrollView subviews]) {
        
        if ([subView isKindOfClass:[UIImageView class]] &&
            subView.frame.origin.x <= 500) {
            
            subView.hidden = YES;
            [subView removeFromSuperview];
        }
    }
}

- (void)dn_webViewLoadWithURL:(NSString *)urlStr {
    
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

@end
