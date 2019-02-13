//
//  UIImage+Extra.m
//  DNProject
//
//  Created by zjs on 2019/1/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "UIImage+Extra.h"

@implementation UIImage (Extra)

+ (UIImage *)dn_imageWithColor:(UIColor *)color {
    
    return [self dn_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)dn_imageWithColor:(UIColor *)color size:(CGSize)size {
    
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  滤镜名字：OriginImage(原图)、CIPhotoEffectNoir(黑白)、CIPhotoEffectInstant(怀旧)、CIPhotoEffectProcess(冲印)、CIPhotoEffectFade(褪色)、CIPhotoEffectTonal(色调)、CIPhotoEffectMono(单色)、CIPhotoEffectChrome(铬黄)
 *
 *  灰色：CIPhotoEffectNoir //黑白
 */
- (UIImage *)dn_addFillter:(NSString *)filterName {
    if ([filterName isEqualToString:@"OriginImage"]) {
        return self;
    }
    // 将 UIImage 装成 CIImage
    CIImage * ciImage = [[CIImage alloc]initWithImage:self];
    // 创建滤镜
    CIFilter * filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey,ciImage, nil];
    // 已有值不变，其他的设置为默认值
    [filter setDefaults];
    // 获取绘制上下文
    CIContext * context = [CIContext contextWithOptions:nil];
    // 渲染并输出 CIImage
    CIImage * outputImage = [filter outputImage];
    // 创建 CGImage 句柄
    CGImageRef cgImgaeRef = [context createCGImage:outputImage fromRect:[outputImage extent]];
    // 获取图片
    UIImage * image = [UIImage imageWithCGImage:cgImgaeRef];
    // 释放 CGImage 句柄
    CGImageRelease(cgImgaeRef);
    return image;
}


/** 图片透明度 */
- (UIImage *)dn_imageAlpha:(CGFloat)alpha {
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, - rect.size.height);
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextSetAlpha(context, alpha);
    CGContextDrawImage(context, rect, self.CGImage);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
/** 设置圆角 */
- (UIImage *)dn_imageCornerRadius:(CGFloat)radius {
    return [self dn_imageCornerRadius:radius borderWidth:0.0f boderColor:nil];
    
}
/** 设置圆角、边框 */
- (UIImage *)dn_imageCornerRadius:(CGFloat)radius
                      borderWidth:(CGFloat)borderWidth
                       boderColor:(UIColor *)borderColor {
    
    return [self dn_imageByRoundCornerRadius:radius
                                     corners:UIRectCornerAllCorners
                                 borderWidth:borderWidth
                                 borderColor:borderColor
                              borderLineJoin:kCGLineJoinMiter];
}

#pragma mark - 设置圆角图片
// corners：需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
- (UIImage *)dn_imageByRoundCornerRadius:(CGFloat)radius
                                 corners:(UIRectCorner)corners
                             borderWidth:(CGFloat)borderWidth
                             borderColor:(UIColor *)borderColor
                          borderLineJoin:(CGLineJoin)borderLineJoin {
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)compressImageWithData:(NSData *)imageData {
    
    CFDataRef dataRef = (__bridge CFDataRef)imageData;
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData(dataRef, nil);
    CFStringRef     sourceType = CGImageSourceGetType(sourceRef);
    
    NSLog(@"%@", sourceType);
}

#pragma mark - 创建二维码
// TODO: 生成二维码
+ (UIImage *)createQRCodeImage:(NSString *)conten {
    
    return [UIImage createQRCodeImage:conten
                              qrColor:UIColor.blackColor
                              bgColor:UIColor.whiteColor];
}

+ (UIImage *)createQRCodeImage:(NSString *)conten qrColor:(UIColor *)qrColor bgColor:(UIColor *)bgColor {
    
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //过滤器恢复默认
    [filter setDefaults];
    //给过滤器添加数据并将NSString格式转化成NSData格式
    NSData *data = [conten dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [filter setValue:data forKeyPath:@"inputMessage"];
    /*
     *  设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
     *
     * L: 7%
     * M: 15%
     * Q: 25%
     * H: 30%
     */
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",filter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:qrColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:bgColor.CGColor],
                             nil];
    CIImage *image = colorFilter.outputImage;
    
    return [UIImage createNonInterPolatCIImage:image];
}

// 解决二维码模糊
+ (UIImage *)createNonInterPolatCIImage:(CIImage *)image {
    
    CGRect extent = CGRectIntegral(image.extent);
    //CGFloat scale = MIN(floatV/CGRectGetWidth(extent), floatV/CGRectGetHeight(extent));
    CGFloat scale = UIScreen.mainScreen.scale;
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark -- 条形码
// TODO: 生成条形码
+ (UIImage *)createBarCodeImage:(NSString *)content {
    
    return [UIImage createBarCodeImage:content
                               qrColor:UIColor.blackColor
                               bgColor:UIColor.whiteColor];
}

+ (UIImage *)createBarCodeImage:(NSString *)content qrColor:(UIColor *)qrColor bgColor:(UIColor *)bgColor {
    
    // 创建条形码
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    // 恢复滤镜的默认属性
    [filter setDefaults];
    // 将字符串转换成NSData
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    // 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 设置二维码不同级别的容错率
    //[filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",filter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:qrColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:bgColor.CGColor],
                             nil];
    // 获得滤镜输出的图像
    CIImage *outputImage = [colorFilter outputImage];
    // 将CIImage转换成UIImage，并放大显示
    UIImage* image =  [UIImage imageWithCIImage:outputImage scale:0 orientation:UIImageOrientationUp];
    return image;
}
@end
