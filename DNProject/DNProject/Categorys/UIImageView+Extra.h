//
//  UIImageView+Extra.h
//  DNProject
//
//  Created by zjs on 2019/1/16.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Extra)

/** 使用 CAShapeLayer 和 UIBezierPath 设置圆角 */
- (void)dn_setBezierPathCornerRadius:(CGFloat)radius;

/** 通过 Graphics 和 BezierPath 设置圆角（推荐用这个）*/
- (void)dn_setGraphicsCornerRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
