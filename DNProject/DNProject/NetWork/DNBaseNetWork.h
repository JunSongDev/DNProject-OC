//
//  DNBaseNetWork.h
//  DNProject
//
//  Created by zjs on 2019/1/15.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNBaseNetWork : NSObject


/**
 @brief POST 请求

 @param urlStr 请求接口
 @param paramter 参数字典
 @param completeHandler 完成回调
 */
+ (void)requestPostWithUrl:(NSString *)urlStr paramter:(id)paramter completerHandler:(void(^)(id responseObjc))completeHandler;


/**
 @brief GET 请求

 @param urlStr 请求接口
 @param paramter 参数字典
 @param completeHandler 完成回调
 */
+ (void)requestGetWithUrl:(NSString *)urlStr paramter:(id)paramter completerHandler:(void(^)(id responseObjc))completeHandler;


/**
 @brief 单图上传

 @param urlStr 请求接口
 @param paramImage 上传的图片
 @param completeHandler 完成回调
 */
+ (void)postImageWithURL:(NSString *)urlStr param:(UIImage *)paramImage completerHandler:(void(^)(id responseObjc))completeHandler;


/**
 @brief 多图上传

 @param urlStr 请求接口
 @param paramArr 上传的图片数组
 @param completeHandler 完成回调
 */
+ (void)postImageWithURL:(NSString *)urlStr params:(NSArray *)paramArr completerHandler:(void(^)(id responseObjc))completeHandler;
@end

NS_ASSUME_NONNULL_END
