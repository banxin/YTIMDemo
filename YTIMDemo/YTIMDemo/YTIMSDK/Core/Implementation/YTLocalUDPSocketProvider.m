//
//  YTLocalUDPSocketProvider.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/5.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTLocalUDPSocketProvider.h"
#import "YTConfigEntity.h"
#import "YTProtocalType.h"
#import "YTClientCoreSDK.h"
#import "YTErrorCode.h"
#import "YTLocalUDPDataReciever.h"

@interface YTLocalUDPSocketProvider ()

@property (nonatomic, retain) GCDAsyncUdpSocket *localUDPSocket;
@property (nonatomic, copy) ConnectionCompletion connectionCompletionOnce_;// block代码块一定要用copy属性，否则报错！

@end

@implementation YTLocalUDPSocketProvider

static YTLocalUDPSocketProvider *instance = nil;

+ (YTLocalUDPSocketProvider *)sharedInstance
{
    if (instance == nil)
    {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

/*!
 * 重置并新建一个全新的Socket对象。
 *
 * @return 新建的全新Socket对象引用
 * @see GCDAsyncUdpSocket
 * @see [ConfigEntity getLocalUDPPort]
 */
- (GCDAsyncUdpSocket *)resetLocalUDPSocket
{
    // 强制关闭本地UDP Socket侦听。
    [self closeLocalUDPSocket];
    
    if([YTClientCoreSDK isENABLED_DEBUG])
        NSLog(@"【IMCORE】new GCDAsyncUdpSocket中...");
    
    // 初始化 localUDPSocket
    self.localUDPSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 获取端口号
    int port = [YTConfigEntity getLocalUdpSendAndListeningPort];
    
    if (port < 0 || port > 65535) {
        
        port = 0;
    }
    
    NSError *error = nil;
    
    // 创建 localUDPSocket 出错
    if (![self.localUDPSocket bindToPort:port error:&error])
    {
        NSLog(@"【IMCORE】localUDPSocket创建时出错，原因是 bindToPort: %@", error);
        return nil;
    }
    
    // 创建 localUDPSocket 出错
    if (![self.localUDPSocket beginReceiving:&error])
    {
        [self closeLocalUDPSocket];
        
        NSLog(@"【IMCORE】localUDPSocket创建时出错，原因是 beginReceiving: %@", error);
        return nil;
    }
    
    if([YTClientCoreSDK isENABLED_DEBUG])
        NSLog(@"【IMCORE】localUDPSocket创建已成功完成.");
    
    return self.localUDPSocket;
}

/*!
 *  尝试连接指定的socket.
 *
 *  UDP是无连接的，此处的连接何解？此处的连接仅是逻辑意义上的操作，实施方法实际动作是进行状态设置等
 *  操作，而带来的方便是每次send数据时就无需再指明主机和端口了.
 *
 *  本框架中，在发送数据前，请首先确保isConnected == YES。
 *
 *  一个注意点是：此connect实际上是异步的，真正意义上能连接上目标主机需等到真正的IMAP包到来。但此机
 *  无需等到异步返回，只需保证coonect从形式上成功即可，即使连接不上主机后绪的QoS保证等机制也会起到错
 *  误告之等。
 *
 *  @param errPtr 本参数为Error的地址，本方法执行返回时如有错误产生则不为空，否则为nil
 *  @param finish 连接结果回调
 *
 *  @return 0 表示connect的意图是否成功发出（实际上真正连接是通过异常的delegate方法回来的，不在此方法考虑之列），否则表示错误码
 *  @see GCDAsyncUdpSocket, ConnectionCompletion
 */
- (int)tryConnectToHost:(NSError **)errPtr withSocket:(GCDAsyncUdpSocket *)skt completion:(ConnectionCompletion)finish
{
    // 服务端IP或域名 不存在时
    if ([YTConfigEntity getServerIp] == nil) {
        
        if ([YTClientCoreSDK isENABLED_DEBUG])
            NSLog(@"【IMCORE】tryConnectToHost到目标主机%@:%d没有成功，ConfigEntity.server_ip==null!", [YTConfigEntity getServerIp], [YTConfigEntity getServerPort]);
        
        // 要连接的服务端网络参数未设置
        return ForC_TO_SERVER_NET_INFO_NOT_SETUP;
    }
    
    NSError *connectError = nil;
    
    if (finish != nil) {
        
        // 存储回调block
        [self setConnectionCompletionOnce_:finish];
    }
    
    // 连接操作
    [skt connectToHost:[YTConfigEntity getServerIp] onPort:[YTConfigEntity getServerPort] error:&connectError];
    
    // 连接失败
    if (connectError != nil) {
        
        if ([YTClientCoreSDK isENABLED_DEBUG]) {
            NSLog(@"【IMCORE】localUDPSocket尝试发出连接到目标主机%@:%d的动作时出错了：%@.(此前isConnected?%d)", [YTConfigEntity getServerIp], [YTConfigEntity getServerPort], connectError, [skt isConnected]);
        }
        
        // 202 与服务端的网络连接失败
        return ForC_BAD_CONNECT_TO_SERVER;
        
        // 连接成功
    } else {
        
        if ([YTClientCoreSDK isENABLED_DEBUG])
            NSLog(@"【IMCORE】localUDPSocket尝试发出连接到目标主机%@:%d的动作成功了.(此前isConnected?%d)", [YTConfigEntity getServerIp], [YTConfigEntity getServerPort], [skt isConnected]);
        
        // 0 一切正常
        return COMMON_CODE_OK;
    }
}

// 本类中的Socket对象是否是健康的。
- (BOOL) isLocalUDPSocketReady
{
    return self.localUDPSocket != nil && ![self.localUDPSocket isClosed];
}

- (GCDAsyncUdpSocket *) getLocalUDPSocket
{
    // 本类中的Socket对象 健康
    if([self isLocalUDPSocketReady]) {
        
        if([YTClientCoreSDK isENABLED_DEBUG])
            NSLog(@"【IMCORE】isLocalUDPSocketReady()==true，直接返回本地socket引用哦。");
        
        // 返回已创建的 localUDPSocket
        return self.localUDPSocket;
        
        // 不健康时
    } else {
        
        if([YTClientCoreSDK isENABLED_DEBUG])
            NSLog(@"【IMCORE】isLocalUDPSocketReady()==false，需要先resetLocalUDPSocket()...");
        
        // 重新设定 localUDPSocket
        return [self resetLocalUDPSocket];
    }
}

// 强制关闭本地UDP Socket侦听。
- (void) closeLocalUDPSocket
{
    if([YTClientCoreSDK isENABLED_DEBUG])
        NSLog(@"【IMCORE】正在closeLocalUDPSocket()...");
    
    // localUDPSocket 存在时
    if (self.localUDPSocket != nil) {
        
        // 关闭 localUDPSocket
        [self.localUDPSocket close];
        // 置空 localUDPSocket
        self.localUDPSocket = nil;
        
    } else {
        
        NSLog(@"【IMCORE】Socket处于未初化状态（可能是您还未登陆），无需关闭。");
    }
}

// 设置UDP Socket连接结果事件观察者.
- (void) setConnectionObserver:(ConnectionCompletion)connObserver
{
    self.connectionCompletionOnce_ = connObserver;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    if([YTClientCoreSDK isENABLED_DEBUG])
        NSLog(@"【UDP_SOCKET】tag为%li的NSData已成功发出.", tag);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    if([YTClientCoreSDK isENABLED_DEBUG])
        NSLog(@"【UDP_SOCKET】tag为%li的NSData没有发送成功，原因是%@", tag, error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
        if([YTClientCoreSDK isENABLED_DEBUG])
            NSLog(@"【UDP_SOCKET】RECV: %@", msg);
        
        [[YTLocalUDPDataReciever sharedInstance] handleProtocal:data];
    }
    else
    {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        
        if([YTClientCoreSDK isENABLED_DEBUG])
            NSLog(@"【UDP_SOCKET】RECV: Unknown message from: %@:%hu", host, port);
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    if([YTClientCoreSDK isENABLED_DEBUG])
        NSLog(@"【UDP_SOCKET】成收到的了UDP的connect反馈, isCOnnected?%d", [sock isConnected]);
    if(self.connectionCompletionOnce_ != nil)
        self.connectionCompletionOnce_(YES);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    if([YTClientCoreSDK isENABLED_DEBUG])
        NSLog(@"【UDP_SOCKET】成收到的了UDP的connect反馈，但连接没有成功, isCOnnected?%d", [sock isConnected]);
    if(self.connectionCompletionOnce_ != nil)
        self.connectionCompletionOnce_(NO);
}

@end
