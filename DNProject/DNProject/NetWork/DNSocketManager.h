//
//  DNSocketManager.h
//  DNProject
//
//  Created by zjs on 2019/2/18.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNSocketManager : NSObject

+ (instancetype)defaultManager;

//建立长连接
- (void)connectServer;
//关闭长连接
- (void)GCDSocketClose;
//发送数据给服务器
- (void)sendDataToServer:(id)data;

@end

NS_ASSUME_NONNULL_END
