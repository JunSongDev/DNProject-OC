//
//  UIButton+Extra.m
//  DNProject
//
//  Created by zjs on 2019/1/16.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "UIButton+Extra.h"
#import <objc/runtime.h>

@implementation UIButton (Extra)

static NSString *insideHandlerKey = @"insideHandlerKey";

- (void)dn_selectorEvenHandler:(TouchHandler)handler {
    
    [self dn_selectorEvent:UIControlEventTouchUpInside handler:^{
       
        handler();
    }];
}

- (void)dn_selectorEvent:(UIControlEvents)events handler:(TouchHandler)handler {
    
    objc_setAssociatedObject(self, &insideHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(selectorEvent) forControlEvents:events];
}

- (void)selectorEvent {
    
    TouchHandler handler = (TouchHandler)objc_getAssociatedObject(self, &insideHandlerKey);
    if (handler) {
        handler();
    }
}

- (void)dn_layoutButtonEdgeInset:(DNEdgeInsetStyle)style space:(CGFloat)space {
    
    /**
     *  前置知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case DNEdgeInsetStyleTop: {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight - space, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight - space, 0);
        } break;
            
        case DNEdgeInsetStyleLeft: {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space / 2.0, 0, space / 2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space / 2.0, 0, -space / 2.0);
        } break;
            
        case DNEdgeInsetStyleBottom: {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight - space / 2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight - space / 2.0, -imageWith, 0, 0);
        } break;
            
        case DNEdgeInsetStyleRight: {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space/2.0, 0, -labelWidth - space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, - imageWith - space/2.0, 0, imageWith + space/2.0);
        } break;
    }
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

- (void)dn_timeDown:(NSInteger)timeDown {
    
    [self dn_timeDown:timeDown downStr:@"" finishStr:@"重新发送"];
}

- (void)dn_timeDown:(NSInteger)timeDown downStr:(NSString *)downStr finishStr:(NSString *)finishStr {
    
    __block NSInteger  time = timeDown;
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每秒执行一次
    dispatch_source_set_timer(_time, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_time, ^{
        
        if (time <= 0) {
            
            dispatch_source_cancel(_time);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.userInteractionEnabled = YES;
                [self setTitle:finishStr forState:UIControlStateNormal];
            });
            
        } else {
            
            int seconds = time % 61;
            NSString *timeStr = [NSString stringWithFormat:@"%.2d s%@", seconds, downStr];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.userInteractionEnabled = NO;
                [self setTitle:timeStr forState:UIControlStateNormal];
            });
            time--;
        }
    });
    dispatch_resume(_time);
}

@end
