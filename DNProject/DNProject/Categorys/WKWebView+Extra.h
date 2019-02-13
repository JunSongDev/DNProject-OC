//
//  WKWebView+Extra.h
//  DNProject
//
//  Created by zjs on 2019/1/16.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (Extra)

// 移除 webView 的背景阴影
- (void)dn_removeBackgroundShadow;

// webView 加载网址
- (void)dn_webViewLoadWithURL:(NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END
