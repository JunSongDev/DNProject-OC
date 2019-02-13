//
//  DNBaseNetWork.m
//  DNProject
//
//  Created by zjs on 2019/1/15.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNBaseNetWork.h"

#define SELF      [DNBaseNetWork shareInstance]
#define ToastView UIApplication.sharedApplication.keyWindow

#define HTTP_HOST @""

@interface DNBaseNetWork ()

@property (nonatomic, strong) AFHTTPSessionManager *afManager;
@end

static DNBaseNetWork *_netWork;

@implementation DNBaseNetWork

/** 单例创建*/
+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_netWork) {
            _netWork = [[self alloc] init];
        }
    });
    return _netWork;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_netWork) {
            _netWork = [super allocWithZone:zone];
        }
    });
    return _netWork;
}

- (id)copyWithZone:(NSZone *)zone {
    return _netWork;
}

/**
 @brief GET 请求
 
 @param urlStr 请求网址
 @param paramter 参数字典
 @param completeHandler 完成回调
 */
+ (void)requestGetWithUrl:(NSString *)urlStr paramter:(id)paramter completerHandler:(void(^)(id responseObjc))completeHandler {
    
    // 检查当前网络状态
    [self netWorkMonitoring];
    // 拼接 URL
    urlStr = [HTTP_HOST stringByAppendingString:urlStr];
    DNLog(@"请求地址：%@%@",urlStr,[self paramsStrWith:paramter]);
    [MBProgressHUD showHUDAddedTo:ToastView animated:YES];
    
    [SELF.afManager GET:urlStr parameters:paramter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:ToastView animated:YES];

        id responseObjc = [SELF transitionJsonString:responseObject];
        
        completeHandler(responseObjc);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DNLog(@"%ld -- > %@", error.code, error);
        
        [MBProgressHUD hideHUDForView:ToastView animated:YES];
        [SELF showErrorToastWithErrorCode:error.code];
    }];
}

/**
 @brief POST 请求
 
 @param urlStr 请求网址
 @param paramter 参数字典
 @param completeHandler 完成回调
 */
+ (void)requestPostWithUrl:(NSString *)urlStr paramter:(id)paramter completerHandler:(void(^)(id responseObjc))completeHandler {
    
    // 检查当前网络状态
    [self netWorkMonitoring];
    // 拼接 URL
    urlStr = [HTTP_HOST stringByAppendingString:urlStr];
    DNLog(@"请求地址：%@%@",urlStr,[self paramsStrWith:paramter]);
    [MBProgressHUD showHUDAddedTo:ToastView animated:YES];
    
    [SELF.afManager POST:urlStr parameters:paramter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:ToastView animated:YES];
        
        id responseObjc = [SELF transitionJsonString:responseObject];
        
        completeHandler(responseObjc);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DNLog(@"%ld -- > %@", error.code, error);
        
        [MBProgressHUD hideHUDForView:ToastView animated:YES];
        [SELF showErrorToastWithErrorCode:error.code];
    }];
}


/**
 @brief 单图上传
 
 @param urlStr 请求接口
 @param paramImage 上传的图片
 @param completeHandler 完成回调
 */
+ (void)postImageWithURL:(NSString *)urlStr param:(UIImage *)paramImage completerHandler:(void(^)(id responseObjc))completeHandler {
    
    // 检查当前网络状态
    [self netWorkMonitoring];
    // 拼接 URL
    urlStr = [HTTP_HOST stringByAppendingString:urlStr];
    SELF.afManager.requestSerializer.timeoutInterval = 15.f;
    
    [SELF.afManager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString * dateStr = [self getCurrentDate];
        NSString * fileName = [NSString stringWithFormat:@"%@.png",dateStr];
        
        NSData * imageData = UIImageJPEGRepresentation(paramImage, 1);
        double scaleNum = (double)300*1024/imageData.length;
        imageData = scaleNum < 1 ? UIImageJPEGRepresentation(paramImage, scaleNum):UIImageJPEGRepresentation(paramImage, 0.1);
        
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpg/png/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:ToastView animated:YES];
        
        id responseObjc = [SELF transitionJsonString:responseObject];
        
        completeHandler(responseObjc);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DNLog(@"%ld -- > %@", error.code, error);
        
        [MBProgressHUD hideHUDForView:ToastView animated:YES];
        [SELF showErrorToastWithErrorCode:error.code];
    }];
}


/**
 @brief 多图上传
 
 @param urlStr 请求接口
 @param paramArr 上传的图片数组
 @param completeHandler 完成回调
 */
+ (void)postImageWithURL:(NSString *)urlStr params:(NSArray *)paramArr completerHandler:(void(^)(id responseObjc))completeHandler {
    
    // 检查当前网络状态
    [self netWorkMonitoring];
    // 拼接 URL
    urlStr = [HTTP_HOST stringByAppendingString:urlStr];
    SELF.afManager.requestSerializer.timeoutInterval = 15.f;
    
    [SELF.afManager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 遍历传进来的数组
        [paramArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // 数组中为图片的 URL
            if ([obj isKindOfClass:[NSString class]]) {
                // 将数组中的 URL 转成 data
                NSData  * data  = [NSData dataWithContentsOfURL:obj];
                UIImage * image = [UIImage imageWithData:data];
                
                NSString * dateStr  = [self getCurrentDate];
                NSString * fileName = [NSString stringWithFormat:@"%@.png",dateStr];
                
                NSData * imageData = UIImageJPEGRepresentation(image, 1);
                double   scaleNum  = (double)300*1024/imageData.length;
                imageData = scaleNum < 1 ? UIImageJPEGRepresentation(image, scaleNum):UIImageJPEGRepresentation(image, 0.1);
                
                [formData appendPartWithFileData:imageData
                                            name:@"file"
                                        fileName:fileName
                                        mimeType:@"image/jpg/png/jpeg"];
            }
            // 图片中为 UIImage
            else if ([obj isKindOfClass:[UIImage class]]) {
                
                NSString * dateStr  = [self getCurrentDate];
                NSString * fileName = [NSString stringWithFormat:@"%@.png",dateStr];
                
                NSData * imageData = UIImageJPEGRepresentation(obj, 1);
                double   scaleNum  = (double)300*1024/imageData.length;
                imageData = scaleNum < 1 ? UIImageJPEGRepresentation(obj, scaleNum):UIImageJPEGRepresentation(obj, 0.1);
                
                [formData appendPartWithFileData:imageData
                                            name:@"file"
                                        fileName:fileName
                                        mimeType:@"image/jpg/png/jpeg"];
            }
            // 数组中为 NSData
            else if ([obj isKindOfClass:[UIImage class]]) {
                NSString * dateStr  = [self getCurrentDate];
                NSString * fileName = [NSString stringWithFormat:@"%@.png",dateStr];
                
                [formData appendPartWithFileData:obj
                                            name:@"file"
                                        fileName:fileName
                                        mimeType:@"image/jpg/png/jpeg"];
            }
            else {
                NSAssert(obj, @"不是支持的数据类型");
            }
            
        }];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:ToastView animated:YES];
        
        id responseObjc = [SELF transitionJsonString:responseObject];
        
        completeHandler(responseObjc);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DNLog(@"%ld -- > %@", error.code, error);
        
        [MBProgressHUD hideHUDForView:ToastView animated:YES];
        [SELF showErrorToastWithErrorCode:error.code];
    }];
}

/**
 @brief  data 转 字典
 
 @param  jsonStr 将要转换的jsonStr
 */
- (id)transitionJsonString:(id)jsonStr {
    
    if (jsonStr == nil) {
        return nil;
    }
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id transitionTmp = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers
                                                         error:&error];
    
    if (transitionTmp) {
        
        if ([transitionTmp isKindOfClass:[NSDictionary class]]) {
            
            return transitionTmp;
        }
        else if ([transitionTmp isKindOfClass:[NSArray class]]) {
            
            return transitionTmp;
        }
        else if ([transitionTmp isKindOfClass:[NSString class]]) {
            
            return transitionTmp;
        }
        else {
            return nil;
        }
    } else {
        DNLog(@"json解析失败：%@",error);
        return nil;
    }
}

/**
 @brief  字典转json字符串方法

 @param dict 字典
 @return 字符串
 */
- (NSString *)convertToJsonData:(NSDictionary *)dict {
    NSError * error;
    // 字典转 data
    NSData  * jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                         options:NSJSONWritingPrettyPrinted
                                                           error:&error];
    NSString *jsonString;
    if (!jsonData) {
        DNLog(@"字典转json字符串错误：%@",error);
    }
    else {
        jsonString = [[NSString alloc]initWithData:jsonData
                                          encoding:NSUTF8StringEncoding];
        // 替换掉 url 地址中的 \/
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    //去掉字符串中的空格
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" "
                            withString:@""
                               options:NSLiteralSearch
                                 range:range];
    
    //去掉字符串中的换行符
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n"
                            withString:@""
                               options:NSLiteralSearch
                                 range:range2];
    
    return mutStr;
}

/**
 @brief  拼接参数
 @param  paramsDict 参数字典
 */
+ (NSString * )paramsStrWith:(NSDictionary *)paramsDict {
    NSString *str = paramsDict.count == 0 ? @"":@"?";
    for (NSString *key in paramsDict) {
        str = [str stringByAppendingString:key];
        str = [str stringByAppendingString:@"="];
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@",[paramsDict objectForKey:key]]];
        str = [str stringByAppendingString:@"&"];
    }
    if (str.length > 1) {
        str = [str substringToIndex:str.length - 1];
    }
    return str;
}

/**
 @brief  获取当前时间
 @return 字符串
 */
+ (NSString *)getCurrentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *formormat = [[NSDateFormatter alloc]init];
    [formormat setDateFormat:@"HH-mm-ss-sss"];
    
    return [formormat stringFromDate:date];
}

// TODO: 检测当前的网络状态
+ (void)netWorkMonitoring {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case -1:
                DNLog(@"未识别网络");
                break;
            case 0:
                DNLog(@"未连接网络");
                break;
            case 1:
                DNLog(@"3G/4G网络");
                break;
            case 2:
                DNLog(@"WIFI网络");
                break;
        }
    }];
}


/**
 @brief 错误码提示弹窗

 @param errorCode 错误码
 */
- (void)showErrorToastWithErrorCode:(NSInteger)errorCode {
    switch (errorCode) {
        case -1001:
            [SELF showErrorMessage:@"请求超时,请检查网络是否异常"];
            break;
        case -1009:
            [SELF showErrorMessage:@"连接网络失败,请检查网络是否异常"];
            break;
        default:
            [SELF showErrorMessage:@"未能连接到服务器,请检查服务是否异常"];
            break;
    }
}
// TODO: 弹窗
- (void)showErrorMessage:(NSString *)message {
    [ToastView makeToast:message duration:1.5 position:CSToastPositionCenter];
}

#pragma mark -- Getter
- (AFHTTPSessionManager *)afManager {
    
    if (!_afManager) {
        _afManager = [AFHTTPSessionManager manager];
        _afManager.requestSerializer.timeoutInterval = 6.f;
        [_afManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [_afManager.requestSerializer didChangeValueForKey: @"timeoutInterval"];
        [_afManager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        _afManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        _afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",
                                                                @"text/plain",
                                                                @"application/json",
                                                                @"text/json",
                                                                @"text/javascript", nil];
        _afManager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        _afManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _afManager;
}

@end
