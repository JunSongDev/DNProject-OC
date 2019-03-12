//
//  DNAlertView.m
//  DNProject
//
//  Created by zjs on 2019/3/7.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNAlertView.h"


static DNAlertView *_alertView = nil;

@implementation DNAlertView

+ (instancetype)defaultAlert {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_alertView) {
            _alertView = [[self alloc] init];
        }
    });
    return _alertView;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_alertView) {
            _alertView = [super allocWithZone:zone];
        }
    });
    return _alertView;
}

- (id)copyWithZone:(NSZone *)zone {
    return _alertView;
}
@end
