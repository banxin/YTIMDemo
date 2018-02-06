//
//  YTLocalUDPDataReciever.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/5.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTLocalUDPDataReciever.h"
#import "YTProtocal.h"
#import "YTProtocalFactory.h"
#import "YTErrorCode.h"
#import "YTProtocalType.h"
#import "YTClientCoreSDK.h"
#import "YTAutoReLoginDaemon.h"
#import "YTLocalUDPDataSender.h"
#import "YTLocalUDPSocketProvider.h"

@implementation YTLocalUDPDataReciever

static YTLocalUDPDataReciever *instance = nil;

+ (YTLocalUDPDataReciever *)sharedInstance
{
    if (instance == nil)
    {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

- (void) handleProtocal:(NSData *)originalProtocalJSONData
{
    if(originalProtocalJSONData == nil)
        return;
    
    YTProtocal *pFromServer = [YTProtocalFactory parse:originalProtocalJSONData];
    
//    if(pFromServer.QoS)
//    {
//        // # Bug FIX B20170620_001 START 【1/2】
//        if(pFromServer.type == FROM_SERVER_TYPE_OF_RESPONSE_LOGIN
//           && [YTProtocalFactory parsePLoginInfoResponse:pFromServer.dataContent].code != 0)
//        {
//            if([ClientCoreSDK isENABLED_DEBUG])
//                NSLog(@"【IMCORE】【BugFIX】这是服务端的登陆返回响应包，且服务端判定登陆失败(即code!=0)，本次无需发送ACK应答包！");
//        }
//        // # Bug FIX 20170620 END 【1/2】
//        else
//        {
//            if([[QoS4SendDaemon sharedInstance] hasRecieved:pFromServer.fp])
//            {
//                if([ClientCoreSDK isENABLED_DEBUG])
//                    NSLog(@"【IMCORE】【QoS机制】%@已经存在于发送列表中，这是重复包，通知应用层收到该包罗！", pFromServer.fp);
//
//                [[QoS4SendDaemon sharedInstance] addRecieved:pFromServer];
//                [self sendRecievedBack:pFromServer];
//
//                return;
//            }
//
//            [[QoS4SendDaemon sharedInstance] addRecieved:pFromServer];
//            [self sendRecievedBack:pFromServer];
//        }
//    }
    
    switch(pFromServer.type)
    {
        case FROM_CLIENT_TYPE_OF_COMMON_DATA:
        {
            if([YTClientCoreSDK sharedInstance].chatTransDataEvent != nil)
            {
                [[YTClientCoreSDK sharedInstance].chatTransDataEvent onTransBuffer:pFromServer.fp withUserId:pFromServer.from andContent:pFromServer.dataContent andTypeu:pFromServer.typeu];
            }
            break;
        }
//        case FROM_SERVER_TYPE_OF_RESPONSE_KEEP_ALIVE:
//        {
//            if([YTClientCoreSDK isENABLED_DEBUG])
//                NSLog(@"【IMCORE】收到服务端回过来的Keep Alive心跳响应包.");
//            [[KeepAliveDaemon sharedInstance] updateGetKeepAliveResponseFromServerTimstamp];
//            break;
//        }
//        case FROM_CLIENT_TYPE_OF_RECIVED:
//        {
//            NSString *theFingerPrint = pFromServer.dataContent;
//            if([YTClientCoreSDK isENABLED_DEBUG])
//                NSLog(@"【IMCORE】【QoS】收到%@发过来的指纹为%@的应答包.", pFromServer.from, theFingerPrint);
//
//            if([YTClientCoreSDK sharedInstance].messageQoSEvent != nil)
//                [[YTClientCoreSDK sharedInstance].messageQoSEvent messagesBeReceived:theFingerPrint];
//
//            [[QoS4ReciveDaemon sharedInstance] remove:theFingerPrint];
//
//            break;
//        }
        case FROM_SERVER_TYPE_OF_RESPONSE_LOGIN:
        {
            YTPLoginInfoResponse *loginInfoRes = [YTProtocalFactory parseYTPLoginInfoResponse:pFromServer.dataContent];
            if(loginInfoRes.code == 0)
            {
                [YTClientCoreSDK sharedInstance].loginHasInit = YES;
                //                [ClientCoreSDK sharedInstance].currentUserId = loginInfoRes.user_id;
                
                [[YTAutoReLoginDaemon sharedInstance] stop];
                
                YTObserverCompletion observerBlock = ^(id observerble ,id data) {
                    //                    [[ProtocalQoS4SendProvider sharedInstance] stop];
//                    [[QoS4SendDaemon sharedInstance] stop];
                    [YTClientCoreSDK sharedInstance].connectedToServer = NO;
                    //                    [ClientCoreSDK sharedInstance].currentUserId = -1;
                    [[YTClientCoreSDK sharedInstance].chatBaseEvent onLinkCloseMessage:-1];
                    [[YTAutoReLoginDaemon sharedInstance] start:YES];
                };
                
//                [[KeepAliveDaemon sharedInstance] setNetworkConnectionLostObserver:observerBlock];
                //                [[KeepAliveDaemon sharedInstance] start:YES];
//                [[KeepAliveDaemon sharedInstance] start:NO];
//                [[QoS4ReciveDaemon sharedInstance] startup:YES];
//                [[QoS4SendDaemon sharedInstance] startup:YES];
                [YTClientCoreSDK sharedInstance].connectedToServer = YES;
            }
            else
            {
                // # Bug FIX B20170620_001 START 【2/2】
                [[YTLocalUDPSocketProvider sharedInstance] closeLocalUDPSocket];
                // # Bug FIX B20170620_001 END 【2/2】
                
                [YTClientCoreSDK sharedInstance].connectedToServer = NO;
                //                [ClientCoreSDK sharedInstance].currentUserId = -1;
            }
            
            if([YTClientCoreSDK sharedInstance].chatBaseEvent != nil)
            {
                [[YTClientCoreSDK sharedInstance].chatBaseEvent onLoginMessage:loginInfoRes.code];
            }
            
            break;
        }
        case FROM_SERVER_TYPE_OF_RESPONSE_FOR_ERROR:
        {
            YTPErrorResponse *errorRes = [YTProtocalFactory parseYTPErrorResponse:pFromServer.dataContent];
            if(errorRes.errorCode == ForS_RESPONSE_FOR_UNLOGIN)
            {
                [YTClientCoreSDK sharedInstance].loginHasInit = NO;
                
                NSLog(@"【IMCORE】收到服务端的“尚未登陆”的错误消息，心跳线程将停止，请应用层重新登陆.");
                
//                [[KeepAliveDaemon sharedInstance] stop];
                [[YTAutoReLoginDaemon sharedInstance] start:NO];
            }
            
            if([YTClientCoreSDK sharedInstance].chatTransDataEvent != nil)
            {
                [[YTClientCoreSDK sharedInstance].chatTransDataEvent onErrorResponse:errorRes.errorCode withErrorMsg:errorRes.errorMsg];
            }
            break;
        }
            
        default:
            NSLog(@"【IMCORE】收到的服务端消息类型：%d，但目前该类型客户端不支持解析和处理！", pFromServer.type);
            break;
    }
}

- (void) sendRecievedBack:(YTProtocal *)pFromServer
{
    if(pFromServer.fp != nil)
    {
        YTProtocal *p = [YTProtocalFactory createRecivedBack:pFromServer.to toUserId:pFromServer.from withFingerPrint:pFromServer.fp andBridge:pFromServer.bridge];
        int sendCode = [[YTLocalUDPDataSender sharedInstance] sendCommonData:p];
        
        if(sendCode == COMMON_CODE_OK)
        {
            if([YTClientCoreSDK isENABLED_DEBUG])
                NSLog(@"【IMCORE】【QoS】向%@发送%@包的应答包成功,from=%@ 【bridge?%d】！", pFromServer.from,pFromServer.fp, pFromServer.to, pFromServer.bridge);
        }
        else
        {
            if([YTClientCoreSDK isENABLED_DEBUG])
                NSLog(@"【IMCORE】【QoS】向%@发送%@包的应答包失败了,错误码=%d！", pFromServer.from,pFromServer.fp, sendCode);
        }
    }
    else
    {
        NSLog(@"【IMCORE】【QoS】收到%@发过来需要QoS的包，但它的指纹码却为null！无法发应答包！", pFromServer.from);
    }
}

@end
