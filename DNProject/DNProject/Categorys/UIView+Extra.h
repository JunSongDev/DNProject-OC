//
//  UIView+Extra.h
//  DNProject
//
//  Created by zjs on 2019/1/16.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extra)

/** Shortcut for frame.origin.x */
@property (nonatomic) CGFloat dn_x;

/** Shortcut for frame.origin.y */
@property (nonatomic) CGFloat dn_y;

/** Shortcut for frame.origin.x */
@property (nonatomic) CGFloat dn_right;

/** Shortcut for frame.origin.x + frame.size.width */
@property (nonatomic) CGFloat dn_bottom;

/** Shortcut for frame.size.width */
@property (nonatomic) CGFloat dn_width;

/** Shortcut for frame.size.height */
@property (nonatomic) CGFloat dn_height;

/** Shortcut for center.x */
@property (nonatomic) CGFloat dn_centerX;

/** Shortcut for center.y */
@property (nonatomic) CGFloat dn_centerY;

/** Shortcut for frame.origin */
@property (nonatomic) CGPoint dn_origin;

/** Shortcut for frame.size */
@property (nonatomic) CGSize  dn_size;

// 创建屏幕快照
- (UIImage *)dn_createSnapshotImage;
// 创建屏幕快照 PDF
- (nullable NSData *)dn_createSnapshotPDF;

/**
 *  @brief  设置阴影
 *
 *  @param  color   阴影颜色
 *  @param  offset  偏移量
 *  @param  radius  圆角
 */
- (void)dn_setLayerShadowColor:(UIColor *)color offset:(CGSize)offset shadowRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
