//
//  UIImage+Extra.h
//  DNProject
//
//  Created by zjs on 2019/1/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extra)

/** 颜色返回一张图片 */
+ (nullable UIImage *)dn_imageWithColor:(UIColor *)color;

/** 颜色返回一张图片(图片大小) */
+ (nullable UIImage *)dn_imageWithColor:(UIColor *)color size:(CGSize)size;

/** 图片滤镜效果 */
- (nullable UIImage *)dn_addFillter:(NSString *)filterName;

/** 图片不透明度 */
- (nullable UIImage *)dn_imageAlpha:(CGFloat)alpha;

/** 设置图片圆角 */
- (nullable UIImage *)dn_imageCornerRadius:(CGFloat)radius;

/**
 *  @brief  图片圆角、边框、边框颜色
 *
 *  @param  radius      圆角半径
 *  @param  borderWidth 边框宽度
 *  @param  borderColor 边框颜色
 */
- (nullable UIImage *)dn_imageCornerRadius:(CGFloat)radius
                               borderWidth:(CGFloat)borderWidth
                                boderColor:(nullable UIColor *)borderColor;

- (void)compressImageWithData:(NSData *)imageData;

/**
 @brief 通过字符串生成二维码 (默认白底黑字)
 
 @param conten 生成二维码的内容
 @return UIImage 二维码图片
 */
+ (UIImage *)createQRCodeImage:(NSString *)conten;

/**
 @brief 通过字符串生成二维码 (自定义二维码和背景颜色)
 
 @param conten 生成二维码的内容
 @param qrColor 二维码颜色
 @param bgColor 背景颜色
 @return UIImage 二维码图片
 */
+ (UIImage *)createQRCodeImage:(NSString *)conten qrColor:(UIColor *)qrColor bgColor:(UIColor *)bgColor;


/**
 @brief 通过字符串生成条形码 (默认白底黑字)
 
 @param content 生成条形码的内容
 @return UIImage 条形码图片
 */
+ (UIImage *)createBarCodeImage:(NSString *)content;

/**
 @brief 通过字符串生成条形码 (自定义条形码和背景颜色)
 
 @param content 生成条形码的内容
 @param qrColor 条形码颜色
 @param bgColor 背景颜色
 @return UIImage 条形码图片
 */
+ (UIImage *)createBarCodeImage:(NSString *)content qrColor:(UIColor *)qrColor bgColor:(UIColor *)bgColor;

@end

NS_ASSUME_NONNULL_END
