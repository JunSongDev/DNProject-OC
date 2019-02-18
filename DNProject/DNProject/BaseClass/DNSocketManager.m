//
//  DNSocketManager.m
//  DNProject
//
//  Created by zjs on 2019/2/18.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNSocketManager.h"
#import <GCDAsyncSocket.h>

// 主线程异步队列
#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

static NSString *s_host = @"";
static uint16_t  s_port = 1111;

@interface DNSocketManager ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;

@property (nonatomic, strong) NSTimer *heartBeatTimer;
@property (nonatomic, strong) NSTimer *networkCheckTimer;

@property (nonatomic, strong) dispatch_queue_t queue; //数据请求队列（串行队列

@property (nonatomic, assign) NSTimeInterval reConnectTime; //重连时间
@property (nonatomic, strong) NSMutableArray *sendDataArray; //存储要发送给服务端的数据

@property (nonatomic, strong) NSMutableData *readBuf; // 缓冲区
//用于判断是否主动关闭长连接，如果是主动断开连接，连接失败的代理中，就不用执行 重新连接方法
@property (nonatomic, assign) BOOL isActivelyClose;

@end

static DNSocketManager *_shareManager = nil;

@implementation DNSocketManager

+ (instancetype)defaultManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareManager) {
            
            _shareManager = [[self alloc] init];
        }
    });
    return _shareManager;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.reConnectTime = 0;
        self.isActivelyClose = NO;
        self.queue = dispatch_queue_create("BF",NULL);
        self.sendDataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - NSTimer
//初始化心跳
- (void)initHeartBeat {
    //心跳没有被关闭
    if(self.heartBeatTimer) {
        return;
    }
    [self destoryHeartBeat];
    
    __weak typeof(self) weakself = self;
    dispatch_main_async_safe(^{
        weakself.heartBeatTimer  = [NSTimer timerWithTimeInterval:10
                                                           target:weakself
                                                         selector:@selector(senderheartBeat)
                                                         userInfo:nil
                                                          repeats:true];
        [[NSRunLoop currentRunLoop] addTimer:weakself.heartBeatTimer forMode:NSRunLoopCommonModes];
    });
}

//取消心跳
- (void)destoryHeartBeat {
    
    __weak typeof(self) weakself = self;
    
    dispatch_main_async_safe(^{
        if(weakself.heartBeatTimer) {
            [weakself.heartBeatTimer invalidate];
            weakself.heartBeatTimer = nil;
        }
    });
}

//没有网络的时候开始定时 -- 用于网络检测
- (void)noNetWorkStartTestingTimer {
    
    __weak typeof(self) weakself = self;
    
    dispatch_main_async_safe(^{
        
        weakself.networkCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                      target:weakself
                                                                    selector:@selector(noNetWorkStartTesting)
                                                                    userInfo:nil
                                                                     repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:weakself.networkCheckTimer forMode:NSDefaultRunLoopMode];
    });
}

//取消网络检测
- (void)destoryNetWorkStartTesting {
    
    __weak typeof(self) weakself = self;
    
    dispatch_main_async_safe(^{
        
        if(weakself.networkCheckTimer) {
            [weakself.networkCheckTimer invalidate];
            weakself.networkCheckTimer = nil;
        }
    });
}

#pragma mark - private -- webSocket相关方法
//发送心跳
- (void)senderheartBeat {
    //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
    __weak typeof(self) weakself = self;
    
    dispatch_main_async_safe(^{
        if(self.socket.isConnected) {

            NSData *heartBeat = [@"" dataUsingEncoding:NSUTF8StringEncoding];
            [weakself.socket writeData:heartBeat withTimeout:-1 tag:0];
        }
    });
}

//定时检测网络
- (void)noNetWorkStartTesting {
    //有网络
    if(AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable) {
        //关闭网络检测定时器
        [self destoryNetWorkStartTesting];
        //开始重连
        [self reConnectServer];
    }
}

//建立长连接
- (void)connectServer {
    self.isActivelyClose = NO;
    
    if(self.socket) {
        self.socket = nil;
    }
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                             delegateQueue:dispatch_get_main_queue()];
    [self.socket connectToHost:s_host onPort:s_port error:nil];
    self.socket.delegate = self;
}

//关闭连接
- (void)SRWebSocketClose {
    
    self.isActivelyClose = YES;
    [self socketDisconnect];
    //关闭心跳定时器
    [self destoryHeartBeat];
    //关闭网络检测定时器
    [self destoryNetWorkStartTesting];
}
- (void)socketDisconnect {
    
    if(self.socket) {
        [self.socket disconnect];
        self.socket = nil;
    }
}

// 重新连接
- (void)reConnectServer {
    
    if (self.socket.isConnected) {
        
        return;
    }
    //重连10次 2^10 = 1024
    if(self.reConnectTime > 1024) {
        self.reConnectTime = 0;
        return;
    }
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.reConnectTime *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        if(weakself.webSocket.readyState == SR_OPEN && weakself.webSocket.readyState == SR_CONNECTING) {
//            return;
//        }
        
        [weakself connectServer];
        NSLog(@"正在重连......");
        //重连时间2的指数级增长
        if(weakself.reConnectTime == 0) {
            weakself.reConnectTime = 2;
        }
        else {
            weakself.reConnectTime *= 2;
        }
    });
    
    //[self.socket connectToHost:s_host onPort:s_port error:nil];
}

// 发送请求
- (void)sendDataToServer:(id)data {
    
    [self.sendDataArray addObject:data];
    [self sendeDataToServer];
}
- (void)sendeDataToServer {
    
    __weak typeof(self) weakself = self;
    //把数据放到一个请求队列中
    dispatch_async(self.queue, ^{
        
        //没有网络
        if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
            //开启网络检测定时器
            [weakself noNetWorkStartTestingTimer];
        }
        //有网络
        else {
            if(weakself.socket != nil) {
                // 判断是否连接
                if(weakself.socket.isConnected) {
                    
                    if (weakself.sendDataArray.count > 0) {
                        
                        NSData *data = [weakself.sendDataArray[0] dataUsingEncoding:NSUTF8StringEncoding];
                        //发送数据
                        [weakself.socket writeData:data withTimeout:-1 tag:0];
                        [weakself.sendDataArray removeObjectAtIndex:0];
                        
                        if([weakself.sendDataArray count] > 0) {
                            
                            [weakself sendeDataToServer];
                        }
                    }
                }
                //正在连接
//                else if (weakself.socket.readyState == SR_CONNECTING) {
//                    NSLog(@"正在连接中，重连后会去自动同步数据");
//                }
                //断开连接
                else if (weakself.socket.isDisconnected) {
                    //调用 reConnectServer 方法重连,连接成功后 继续发送数据
                    [weakself reConnectServer];
                }
            }
            else {
                //连接服务器
                [weakself connectServer];
            }
        }
    });
}

#pragma mark -- GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
    DNLog(@"建立连接成功");
    //
    self.readBuf = [[NSMutableData alloc] init];
    //开启心跳
    [self initHeartBeat];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    // 在这里可以进行重连
    DNLog(@"建立连接失败 ------> %@", err);
    // 重新连接
    [self reConnectServer];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
    DNLog(@"请求发送成功");
}

// 读取数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    // 根据需求进行数据解析
    [self.readBuf appendData:data];
    
}
@end
