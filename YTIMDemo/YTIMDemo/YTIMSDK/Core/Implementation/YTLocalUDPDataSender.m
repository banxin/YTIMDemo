//
//  YTLocalUDPDataSender.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/5.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTLocalUDPDataSender.h"
#import "YTClientCoreSDK.h"
#import "YTErrorCode.h"
#import "YTProtocalType.h"
#import "GCDAsyncUdpSocket.h"
#import "YTLocalUDPSocketProvider.h"
#import "YTUDPUtils.h"
#import "YTProtocalFactory.h"

static YTLocalUDPDataSender *instance = nil;

@implementation YTLocalUDPDataSender

// 发送 请求
- (int) sendImpl_:(NSData *)fullProtocalBytes
{
    if(![[YTClientCoreSDK sharedInstance] isInitialed])
        
        // 客户端SDK尚未初始化
        return ForC_CLIENT_SDK_NO_INITIALED;
    
    if(![YTClientCoreSDK sharedInstance].localDeviceNetworkOk)
    {
        NSLog(@"【IMCORE】本地网络不能工作，send数据没有继续!");
        return ForC_LOCAL_NETWORK_NOT_WORKING;
    }
    
    // 获得本地UDPSocket的实例引用
    GCDAsyncUdpSocket *ds = [[YTLocalUDPSocketProvider sharedInstance] getLocalUDPSocket];
    
    // UDPSocket 事例 不存在 且 未连接的场合
    if (ds != nil && ![ds isConnected]) {
        
        // UDP Socket连接结果回调
        ConnectionCompletion observerBlock = ^(BOOL connectResult) {
            
            // 连接成功
            if (connectResult) {
                
                // 发送一条UDP消息
                [YTUDPUtils send:ds withData:fullProtocalBytes];
                
            } else {
                
            }
        };
        
        [[YTLocalUDPSocketProvider sharedInstance] setConnectionObserver:observerBlock];
        
        NSError *connectError = nil;
        
        // 尝试连接指定的socket
        int connectCode = [[YTLocalUDPSocketProvider sharedInstance] tryConnectToHost:&connectError withSocket:ds completion:observerBlock];
        
        // 非正常场合
        if (connectCode != COMMON_CODE_OK) {
            
            // 返回对应的错误码
            return connectCode;
            
        } else {
            
            // 返回一切正常
            return COMMON_CODE_OK;
        }
        
        // UDPSocket 存在时
    } else {
        
        // 发送成功 返回 0 - 一切正常 否则 返回 3 - 数据发送失败
        return [YTUDPUtils send:ds withData:fullProtocalBytes] ? COMMON_CODE_OK : COMMON_DATA_SEND_FAILD;
    }
}

+ (YTLocalUDPDataSender *)sharedInstance
{
    if (instance == nil)
    {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

/*!
 * 发送登陆信息(默认extra字段值为nil哦).
 * <p>
 * 本方法中已经默认进行了核心库的初始化，因而使用本类完成登陆时，就无需单独
 * 调用初始化方法[ClientCoreSDK initCore]了。
 *
 * @warning 本库的启动入口就是登陆过程触发的，因而要使本库能正常工作，
 * 请确保首先进行登陆操作。
 * @param loginUserId 提交到服务端的准一id，保证唯一就可以通信，可能是登陆用户名、
 * 也可能是任意不重复的id等，具体意义由业务层决定
 * @param loginToken 提交到服务端用于身份鉴别和合法性检查的token，它可能是登陆密码
 * ，也可能是通过前置单点登陆接口拿到的token等，具体意义由业务层决定
 * @return 0表示数据发出成功，否则返回的是错误码
 * @see [LocalUDPDataSender sendLogin:withPassword:andExtra:]
 */
- (int) sendLogin:(NSString *)loginUserId withToken:(NSString *)loginToken
{
    return [self sendLogin:loginUserId withToken:loginToken andExtra:nil];
}

/*!
 * 发送登陆信息.
 * <p>
 * 本方法中已经默认进行了核心库的初始化，因而使用本类完成登陆时，就无需单独
 * 调用初始化方法[ClientCoreSDK initCore]了。
 *
 * @warning 本库的启动入口就是登陆过程触发的，因而要使本库能正常工作，
 * 请确保首先进行登陆操作。
 * @param loginUserId 提交到服务端的准一id，保证唯一就可以通信，可能是登陆用户名、
 * 也可能是任意不重复的id等，具体意义由业务层决定
 * @param loginToken 提交到服务端用于身份鉴别和合法性检查的token，它可能是登陆密码
 * ，也可能是通过前置单点登陆接口拿到的token等，具体意义由业务层决定
 * @param extra 额外信息字符串，可为null。本字段目前为保留字段，供上层应用自行放置需要的内容
 * @return 0表示数据发出成功，否则返回的是错误码
 * @see [LocalUDPDataSender sendImpl_:(NSData *)]
 */
- (int) sendLogin:(NSString *)loginUserId withToken:(NSString *)loginToken andExtra:(NSString *)extra
{
    // 初始化 ClientCoreSDK
    [[YTClientCoreSDK sharedInstance] initCore];
    
    // 创建用户登陆消息对象
    NSData *b = [[YTProtocalFactory createPLoginInfo:loginUserId withToken:loginToken andExtra:extra] toBytes];
    
    int code = [self sendImpl_:b];
    if(code == 0)
    {
        [[YTClientCoreSDK sharedInstance] setCurrentLoginUserId:loginUserId];
        [[YTClientCoreSDK sharedInstance] setCurrentLoginToken:loginToken];
        [[YTClientCoreSDK sharedInstance] setCurrentLoginExtra:extra];
    }
    
    return code;
}

- (int) sendLoginout
{
    int code = COMMON_CODE_OK;
    if([YTClientCoreSDK sharedInstance].loginHasInit)
    {
        NSString *loginUserId = [YTClientCoreSDK sharedInstance].currentLoginUserId;
        NSData *b = [[YTProtocalFactory createPLoginoutInfo:loginUserId] toBytes];
        code = [self sendImpl_:b];
        if(code == 0)
        {
//            [[KeepAliveDaemon sharedInstance] stop];
            [[YTClientCoreSDK sharedInstance] setLoginHasInit:NO];
        }
    }
    
    [[YTClientCoreSDK sharedInstance] releaseCore];
    
    return code;
}

- (int) sendCommonDataWithStr:(NSString *)dataContentWidthStr toUserId:(NSString *)to_user_id
{
    return [self sendCommonDataWithStr:dataContentWidthStr toUserId:to_user_id withTypeu:-1];
}

- (int) sendCommonDataWithStr:(NSString *)dataContentWidthStr toUserId:(NSString *)to_user_id withTypeu:(int)typeu
{
    NSString *currentLoginUserId = [[YTClientCoreSDK sharedInstance] currentLoginUserId];
    YTProtocal *p = [YTProtocalFactory createCommonData:dataContentWidthStr fromUserId:currentLoginUserId toUserId:to_user_id withTypeu:typeu];
    return [self sendCommonData:p];
}

- (int) sendCommonDataWithStr:(NSString *)dataContentWidthStr toUserId:(NSString *)to_user_id qos:(BOOL)QoS fp:(NSString *)fingerPrint withTypeu:(int)typeu
{
    NSString *currentLoginUserId = [[YTClientCoreSDK sharedInstance] currentLoginUserId];
    YTProtocal *p = [YTProtocalFactory createCommonData:dataContentWidthStr fromUserId:currentLoginUserId toUserId:to_user_id qos:QoS fp:fingerPrint withTypeu:typeu];
    return [self sendCommonData:p];
}

- (int) sendCommonData:(YTProtocal *)p
{
    @synchronized(self)
    {
        if(p != nil)
        {
            NSData *b = [p toBytes];
            int code = [self sendImpl_:b];
//            if(code == 0)
//            {
//                [self putToQoS:p];
//            }
            return code;
        }
        else
            return COMMON_INVALID_PROTOCAL;
    }
}

@end










